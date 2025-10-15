#!/bin/bash

# ==================================================
# PROTECT BY ZERO - PANEL PROTECTION SCRIPT
# Created by: ZeroHosting
# Version: 1.0
# ==================================================

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Banner
echo -e "${BLUE}"
echo "=================================================="
echo "           PROTECT BY ZERO INSTALLER"
echo "           Created by ZeroHosting"
echo "=================================================="
echo -e "${NC}"

# Function to print colored output
print_status() {
    echo -e "${GREEN}[✓] $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}[!] $1${NC}"
}

print_error() {
    echo -e "${RED}[✗] $1${NC}"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    print_error "This script should not be run as root"
    exit 1
fi

# Check if we're in the correct directory
if [[ ! -d "/var/www/pterodactyl" ]]; then
    print_error "Pterodactyl panel not found in /var/www/pterodactyl"
    print_error "Please run this script from your Pterodactyl installation directory"
    exit 1
fi

# Backup directory
BACKUP_DIR="/var/www/pterodactyl/backups/protect_zero_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Function to create backup
backup_file() {
    local file="$1"
    if [[ -f "$file" ]]; then
        cp "$file" "$BACKUP_DIR/"
        print_status "Backed up: $(basename "$file")"
    fi
}

# Function to replace file content
replace_file() {
    local file="$1"
    local content="$2"
    local description="$3"
    
    backup_file "$file"
    
    # Create directory if it doesn't exist
    mkdir -p "$(dirname "$file")"
    
    # Write content to file
    echo "$content" > "$file"
    
    if [[ $? -eq 0 ]]; then
        print_status "Installed: $description"
    else
        print_error "Failed to install: $description"
        return 1
    fi
}

# ==================================================
# 1. ANTI DELETE SERVER
# ==================================================

SERVER_DELETION_SERVICE='<?php

namespace Pterodactyl\Services\Servers;

use Illuminate\Support\Facades\Auth;
use Pterodactyl\Exceptions\DisplayException;
use Illuminate\Http\Response;
use Pterodactyl\Models\Server;
use Illuminate\Support\Facades\Log;
use Illuminate\Database\ConnectionInterface;
use Pterodactyl\Repositories\Wings\DaemonServerRepository;
use Pterodactyl\Services\Databases\DatabaseManagementService;
use Pterodactyl\Exceptions\Http\Connection\DaemonConnectionException;

class ServerDeletionService
{
    protected bool $force = false;

    /**
     * ServerDeletionService constructor.
     */
    public function __construct(
        private ConnectionInterface $connection,
        private DaemonServerRepository $daemonServerRepository,
        private DatabaseManagementService $databaseManagementService
    ) {
    }

    /**
     * Set if the server should be forcibly deleted from the panel (ignoring daemon errors) or not.
     */
    public function withForce(bool $bool = true): self
    {
        $this->force = $bool;
        return $this;
    }

    /**
     * Delete a server from the panel and remove any associated databases from hosts.
     *
     * @throws \Throwable
     * @throws \Pterodactyl\Exceptions\DisplayException
     */
    public function handle(Server $server): void
    {
        $user = Auth::user();

        // 🔒 Proteksi: hanya Admin ID = 1 boleh menghapus server siapa saja.
        // Selain itu, user biasa hanya boleh menghapus server MILIKNYA SENDIRI.
        // Jika tidak ada informasi pemilik dan pengguna bukan admin, tolak.
        if ($user) {
            if ($user->id !== 1) {
                // Coba deteksi owner dengan beberapa fallback yang umum.
                $ownerId = $server->owner_id
                    ?? $server->user_id
                    ?? ($server->owner?->id ?? null)
                    ?? ($server->user?->id ?? null);

                if ($ownerId === null) {
                    // Tidak jelas siapa pemiliknya — jangan izinkan pengguna biasa menghapus.
                    throw new DisplayException('Akses ditolak: informasi pemilik server tidak tersedia.');
                }

                if ($ownerId !== $user->id) {
                    throw new DisplayException('Akses ditolak: Anda hanya dapat menghapus server milik Anda sendiri @ PROTECT BY ZERO - ZeroHosting');
                }
            }
            // jika $user->id === 1, lanjutkan (admin super)
        }
        // Jika tidak ada $user (mis. CLI/background job), biarkan proses berjalan.

        try {
            $this->daemonServerRepository->setServer($server)->delete();
        } catch (DaemonConnectionException $exception) {
            // Abaikan error 404, tapi lempar error lain jika tidak mode force
            if (!$this->force && $exception->getStatusCode() !== Response::HTTP_NOT_FOUND) {
                throw $exception;
            }

            Log::warning($exception);
        }

        $this->connection->transaction(function () use ($server) {
            foreach ($server->databases as $database) {
                try {
                    $this->databaseManagementService->delete($database);
                } catch (\Exception $exception) {
                    if (!$this->force) {
                        throw $exception;
                    }

                    // Jika gagal delete database di host, tetap hapus dari panel
                    $database->delete();
                    Log::warning($exception);
                }
            }

            $server->delete();
        });
    }
}'

# ==================================================
# 2. ANTI DELETE USER
# ==================================================

USER_CONTROLLER='<?php

namespace Pterodactyl\Http\Controllers\Admin;

use Illuminate\View\View;
use Illuminate\Http\Request;
use Pterodactyl\Models\User;
use Pterodactyl\Models\Model;
use Illuminate\Support\Collection;
use Illuminate\Http\RedirectResponse;
use Prologue\Alerts\AlertsMessageBag;
use Spatie\QueryBuilder\QueryBuilder;
use Illuminate\View\Factory as ViewFactory;
use Pterodactyl\Exceptions\DisplayException;
use Pterodactyl\Http\Controllers\Controller;
use Illuminate\Contracts\Translation\Translator;
use Pterodactyl\Services\Users\UserUpdateService;
use Pterodactyl\Traits\Helpers\AvailableLanguages;
use Pterodactyl\Services\Users\UserCreationService;
use Pterodactyl\Services\Users\UserDeletionService;
use Pterodactyl\Http\Requests\Admin\UserFormRequest;
use Pterodactyl\Http\Requests\Admin\NewUserFormRequest;
use Pterodactyl\Contracts\Repository\UserRepositoryInterface;

class UserController extends Controller
{
    use AvailableLanguages;

    /**
     * UserController constructor.
     */
    public function __construct(
        protected AlertsMessageBag $alert,
        protected UserCreationService $creationService,
        protected UserDeletionService $deletionService,
        protected Translator $translator,
        protected UserUpdateService $updateService,
        protected UserRepositoryInterface $repository,
        protected ViewFactory $view
    ) {
    }

    /**
     * Display user index page.
     */
    public function index(Request $request): View
    {
        $users = QueryBuilder::for(
            User::query()->select('users.*')
                ->selectRaw('COUNT(DISTINCT(subusers.id)) as subuser_of_count')
                ->selectRaw('COUNT(DISTINCT(servers.id)) as servers_count')
                ->leftJoin('subusers', 'subusers.user_id', '=', 'users.id')
                ->leftJoin('servers', 'servers.owner_id', '=', 'users.id')
                ->groupBy('users.id')
        )
            ->allowedFilters(['username', 'email', 'uuid'])
            ->allowedSorts(['id', 'uuid'])
            ->paginate(50);

        return $this->view->make('admin.users.index', ['users' => $users]);
    }

    /**
     * Display new user page.
     */
    public function create(): View
    {
        return $this->view->make('admin.users.new', [
            'languages' => $this->getAvailableLanguages(true),
        ]);
    }

    /**
     * Display user view page.
     */
    public function view(User $user): View
    {
        return $this->view->make('admin.users.view', [
            'user' => $user,
            'languages' => $this->getAvailableLanguages(true),
        ]);
    }

    /**
     * Delete a user from the system.
     *
     * @throws \Exception
     * @throws \Pterodactyl\Exceptions\DisplayException
     */
    public function delete(Request $request, User $user): RedirectResponse
    {
        // === FITUR TAMBAHAN: Proteksi hapus user ===
        if ($request->user()->id !== 1) {
            throw new DisplayException("❌ Hanya admin ID 1 yang dapat menghapus user lain! © Protect by Zero - ZeroHosting V1.0");
        }
        // ============================================

        if ($request->user()->id === $user->id) {
            throw new DisplayException($this->translator->get('admin/user.exceptions.user_has_servers'));
        }

        $this->deletionService->handle($user);

        return redirect()->route('admin.users');
    }

    /**
     * Create a user.
     *
     * @throws \Exception
     * @throws \Throwable
     */
    public function store(NewUserFormRequest $request): RedirectResponse
    {
        $user = $this->creationService->handle($request->normalize());
        $this->alert->success($this->translator->get('admin/user.notices.account_created'))->flash();

        return redirect()->route('admin.users.view', $user->id);
    }

    /**
     * Update a user on the system.
     *
     * @throws \Pterodactyl\Exceptions\Model\DataValidationException
     * @throws \Pterodactyl\Exceptions\Repository\RecordNotFoundException
     */
    public function update(UserFormRequest $request, User $user): RedirectResponse
    {
        // === FITUR TAMBAHAN: Proteksi ubah data penting ===
        $restrictedFields = ['email', 'first_name', 'last_name', 'password'];

        foreach ($restrictedFields as $field) {
            if ($request->filled($field) && $request->user()->id !== 1) {
                throw new DisplayException("⚠️ Data hanya bisa diubah oleh admin ID 1. © Protect by Zero - ZeroHosting V1.0");
            }
        }

        // Cegah turunkan level admin ke user biasa
        if ($user->root_admin && $request->user()->id !== 1) {
            throw new DisplayException("🚫 Tidak dapat menurunkan hak admin pengguna ini. Hanya ID 1 yang memiliki izin. © PROTECT BY ZERO - ZeroHosting V1.0");
        }
        // ====================================================

        $this->updateService
            ->setUserLevel(User::USER_LEVEL_ADMIN)
            ->handle($user, $request->normalize());

        $this->alert->success(trans('admin/user.notices.account_updated'))->flash();

        return redirect()->route('admin.users.view', $user->id);
    }

    /**
     * Get a JSON response of users on the system.
     */
    public function json(Request $request): Model|Collection
    {
        $users = QueryBuilder::for(User::query())->allowedFilters(['email'])->paginate(25);

        // Handle single user requests.
        if ($request->query('user_id')) {
            $user = User::query()->findOrFail($request->input('user_id'));
            $user->md5 = md5(strtolower($user->email));

            return $user;
        }

        return $users->map(function ($item) {
            $item->md5 = md5(strtolower($item->email));

            return $item;
        });
    }
}'

# ==================================================
# 3. ANTI INTIP LOCATION
# ==================================================

LOCATION_CONTROLLER='<?php

namespace Pterodactyl\Http\Controllers\Admin;

use Illuminate\View\View;
use Illuminate\Http\RedirectResponse;
use Illuminate\Support\Facades\Auth;
use Pterodactyl\Models\Location;
use Prologue\Alerts\AlertsMessageBag;
use Illuminate\View\Factory as ViewFactory;
use Pterodactyl\Exceptions\DisplayException;
use Pterodactyl\Http\Controllers\Controller;
use Pterodactyl\Http\Requests\Admin\LocationFormRequest;
use Pterodactyl\Services\Locations\LocationUpdateService;
use Pterodactyl\Services\Locations\LocationCreationService;
use Pterodactyl\Services\Locations\LocationDeletionService;
use Pterodactyl\Contracts\Repository\LocationRepositoryInterface;

class LocationController extends Controller
{
    /**
     * LocationController constructor.
     */
    public function __construct(
        protected AlertsMessageBag $alert,
        protected LocationCreationService $creationService,
        protected LocationDeletionService $deletionService,
        protected LocationRepositoryInterface $repository,
        protected LocationUpdateService $updateService,
        protected ViewFactory $view
    ) {
    }

    /**
     * Return the location overview page.
     */
    public function index(): View
    {
        // 🔒 Cegah akses selain admin ID 1
        $user = Auth::user();
        if (!$user || $user->id !== 1) {
            abort(403, 'Protect by Zero - Akses ditolak');
        }

        return $this->view->make('admin.locations.index', [
            'locations' => $this->repository->getAllWithDetails(),
        ]);
    }

    /**
     * Return the location view page.
     *
     * @throws \Pterodactyl\Exceptions\Repository\RecordNotFoundException
     */
    public function view(int $id): View
    {
        // 🔒 Cegah akses selain admin ID 1
        $user = Auth::user();
        if (!$user || $user->id !== 1) {
            abort(403, 'Protect by Zero - Akses ditolak');
        }

        return $this->view->make('admin.locations.view', [
            'location' => $this->repository->getWithNodes($id),
        ]);
    }

    /**
     * Handle request to create new location.
     *
     * @throws \Throwable
     */
    public function create(LocationFormRequest $request): RedirectResponse
    {
        // 🔒 Cegah akses selain admin ID 1
        $user = Auth::user();
        if (!$user || $user->id !== 1) {
            abort(403, 'Protect by Zero - Akses ditolak');
        }

        $location = $this->creationService->handle($request->normalize());
        $this->alert->success('Location was created successfully.')->flash();

        return redirect()->route('admin.locations.view', $location->id);
    }

    /**
     * Handle request to update or delete location.
     *
     * @throws \Throwable
     */
    public function update(LocationFormRequest $request, Location $location): RedirectResponse
    {
        // 🔒 Cegah akses selain admin ID 1
        $user = Auth::user();
        if (!$user || $user->id !== 1) {
            abort(403, 'Protect by Zero - Akses ditolak');
        }

        if ($request->input('action') === 'delete') {
            return $this->delete($location);
        }

        $this->updateService->handle($location->id, $request->normalize());
        $this->alert->success('Location was updated successfully.')->flash();

        return redirect()->route('admin.locations.view', $location->id);
    }

    /**
     * Delete a location from the system.
     *
     * @throws \Exception
     * @throws \Pterodactyl\Exceptions\DisplayException
     */
    public function delete(Location $location): RedirectResponse
    {
        // 🔒 Cegah akses selain admin ID 1
        $user = Auth::user();
        if (!$user || $user->id !== 1) {
            abort(403, 'Protect by Zero - Akses ditolak');
        }

        try {
            $this->deletionService->handle($location->id);
            return redirect()->route('admin.locations');
        } catch (DisplayException $ex) {
            $this->alert->danger($ex->getMessage())->flash();
        }

        return redirect()->route('admin.locations.view', $location->id);
    }
}'

# ==================================================
# 4. ANTI INTIP NODES
# ==================================================

NODE_CONTROLLER='<?php

namespace Pterodactyl\Http\Controllers\Admin\Nodes;

use Illuminate\View\View;
use Illuminate\Http\Request;
use Pterodactyl\Models\Node;
use Spatie\QueryBuilder\QueryBuilder;
use Pterodactyl\Http\Controllers\Controller;
use Illuminate\Contracts\View\Factory as ViewFactory;
use Illuminate\Support\Facades\Auth;

class NodeController extends Controller
{
    /**
     * NodeController constructor.
     */
    public function __construct(private ViewFactory $view)
    {
    }

    /**
     * Returns a listing of nodes on the system.
     */
    public function index(Request $request): View
    {
        // === 🔒 FITUR TAMBAHAN: Anti akses selain admin ID 1 ===
        $user = Auth::user();
        if (!$user || $user->id !== 1) {
            abort(403, '🚫 Akses ditolak! Hanya admin ID 1 yang dapat membuka menu Nodes. © Protect by Zero - ZeroHosting V1.0');
        }
        // ======================================================

        $nodes = QueryBuilder::for(
            Node::query()->with('location')->withCount('servers')
        )
            ->allowedFilters(['uuid', 'name'])
            ->allowedSorts(['id'])
            ->paginate(25);

        return $this->view->make('admin.nodes.index', ['nodes' => $nodes]);
    }
}'

# ==================================================
# 5. ANTI INTIP NEST
# ==================================================

NEST_CONTROLLER='<?php

namespace Pterodactyl\Http\Controllers\Admin\Nests;

use Illuminate\View\View;
use Illuminate\Http\RedirectResponse;
use Prologue\Alerts\AlertsMessageBag;
use Illuminate\View\Factory as ViewFactory;
use Pterodactyl\Http\Controllers\Controller;
use Pterodactyl\Services\Nests\NestUpdateService;
use Pterodactyl\Services\Nests\NestCreationService;
use Pterodactyl\Services\Nests\NestDeletionService;
use Pterodactyl\Contracts\Repository\NestRepositoryInterface;
use Pterodactyl\Http\Requests\Admin\Nest\StoreNestFormRequest;
use Illuminate\Support\Facades\Auth;

class NestController extends Controller
{
    /**
     * NestController constructor.
     */
    public function __construct(
        protected AlertsMessageBag $alert,
        protected NestCreationService $nestCreationService,
        protected NestDeletionService $nestDeletionService,
        protected NestRepositoryInterface $repository,
        protected NestUpdateService $nestUpdateService,
        protected ViewFactory $view
    ) {
    }

    /**
     * Render nest listing page.
     *
     * @throws \Pterodactyl\Exceptions\Repository\RecordNotFoundException
     */
    public function index(): View
    {
        // 🔒 Proteksi: hanya user ID 1 (superadmin) yang bisa akses menu Nest
        $user = Auth::user();
        if (!$user || $user->id !== 1) {
            abort(403, '🚫 Akses ditolak! Hanya admin utama (ID 1) yang bisa membuka menu Nests. © Protect by Zero - ZeroHosting V1.0');
        }

        return $this->view->make('admin.nests.index', [
            'nests' => $this->repository->getWithCounts(),
        ]);
    }

    /**
     * Render nest creation page.
     */
    public function create(): View
    {
        return $this->view->make('admin.nests.new');
    }

    /**
     * Handle the storage of a new nest.
     *
     * @throws \Pterodactyl\Exceptions\Model\DataValidationException
     */
    public function store(StoreNestFormRequest $request): RedirectResponse
    {
        $nest = $this->nestCreationService->handle($request->normalize());
        $this->alert->success(trans('admin/nests.notices.created', ['name' => htmlspecialchars($nest->name)]))->flash();

        return redirect()->route('admin.nests.view', $nest->id);
    }

    /**
     * Return details about a nest including all the eggs and servers per egg.
     *
     * @throws \Pterodactyl\Exceptions\Repository\RecordNotFoundException
     */
    public function view(int $nest): View
    {
        return $this->view->make('admin.nests.view', [
            'nest' => $this->repository->getWithEggServers($nest),
        ]);
    }

    /**
     * Handle request to update a nest.
     *
     * @throws \Pterodactyl\Exceptions\Model\DataValidationException
     * @throws \Pterodactyl\Exceptions\Repository\RecordNotFoundException
     */
    public function update(StoreNestFormRequest $request, int $nest): RedirectResponse
    {
        $this->nestUpdateService->handle($nest, $request->normalize());
        $this->alert->success(trans('admin/nests.notices.updated'))->flash();

        return redirect()->route('admin.nests.view', $nest);
    }

    /**
     * Handle request to delete a nest.
     *
     * @throws \Pterodactyl\Exceptions\Service\HasActiveServersException
     */
    public function destroy(int $nest): RedirectResponse
    {
        $this->nestDeletionService->handle($nest);
        $this->alert->success(trans('admin/nests.notices.deleted'))->flash();

        return redirect()->route('admin.nests');
    }
}'

# ==================================================
# 6. ANTI INTIP SETTINGS
# ==================================================

SETTINGS_CONTROLLER='<?php

namespace Pterodactyl\Http\Controllers\Admin\Settings;

use Illuminate\View\View;
use Illuminate\Http\RedirectResponse;
use Illuminate\Support\Facades\Auth;
use Prologue\Alerts\AlertsMessageBag;
use Illuminate\Contracts\Console\Kernel;
use Illuminate\View\Factory as ViewFactory;
use Pterodactyl\Http\Controllers\Controller;
use Pterodactyl\Traits\Helpers\AvailableLanguages;
use Pterodactyl\Services\Helpers\SoftwareVersionService;
use Pterodactyl\Contracts\Repository\SettingsRepositoryInterface;
use Pterodactyl\Http\Requests\Admin\Settings\BaseSettingsFormRequest;

class IndexController extends Controller
{
    use AvailableLanguages;

    /**
     * IndexController constructor.
     */
    public function __construct(
        private AlertsMessageBag $alert,
        private Kernel $kernel,
        private SettingsRepositoryInterface $settings,
        private SoftwareVersionService $versionService,
        private ViewFactory $view
    ) {
    }

    /**
     * Render the UI for basic Panel settings.
     */
    public function index(): View
    {
        // 🔒 Anti akses menu Settings selain user ID 1
        $user = Auth::user();
        if (!$user || $user->id !== 1) {
            abort(403, 'Protect by Zero - Akses ditolak❌');
        }

        return $this->view->make('admin.settings.index', [
            'version' => $this->versionService,
            'languages' => $this->getAvailableLanguages(true),
        ]);
    }

    /**
     * Handle settings update.
     *
     * @throws \Pterodactyl\Exceptions\Model\DataValidationException
     * @throws \Pterodactyl\Exceptions\Repository\RecordNotFoundException
     */
    public function update(BaseSettingsFormRequest $request): RedirectResponse
    {
        // 🔒 Anti akses update settings selain user ID 1
        $user = Auth::user();
        if (!$user || $user->id !== 1) {
            abort(403, 'Protect by Zero - Akses ditolak');
        }

        foreach ($request->normalize() as $key => $value) {
            $this->settings->set('settings::' . $key, $value);
        }

        $this->kernel->call('queue:restart');
        $this->alert->success(
            'Panel settings have been updated successfully and the queue worker was restarted to apply these changes.'
        )->flash();

        return redirect()->route('admin.settings');
    }
}'

# ==================================================
# MAIN INSTALLATION
# ==================================================

echo -e "${BLUE}Starting Protect by Zero installation...${NC}"
echo ""

# Install all protection files
print_status "Installing protection modules..."

# 1. Anti Delete Server
replace_file "/var/www/pterodactyl/app/Services/Servers/ServerDeletionService.php" "$SERVER_DELETION_SERVICE" "Anti Delete Server Protection"

# 2. Anti Delete User  
replace_file "/var/www/pterodactyl/app/Http/Controllers/Admin/UserController.php" "$USER_CONTROLLER" "Anti Delete User Protection"

# 3. Anti Intip Location
replace_file "/var/www/pterodactyl/app/Http/Controllers/Admin/LocationController.php" "$LOCATION_CONTROLLER" "Anti Intip Location Protection"

# 4. Anti Intip Nodes
replace_file "/var/www/pterodactyl/app/Http/Controllers/Admin/Nodes/NodeController.php" "$NODE_CONTROLLER" "Anti Intip Nodes Protection"

# 5. Anti Intip Nest
replace_file "/var/www/pterodactyl/app/Http/Controllers/Admin/Nests/NestController.php" "$NEST_CONTROLLER" "Anti Intip Nest Protection"

# 6. Anti Intip Settings
replace_file "/var/www/pterodactyl/app/Http/Controllers/Admin/Settings/IndexController.php" "$SETTINGS_CONTROLLER" "Anti Intip Settings Protection"

echo ""
print_status "All protection modules installed successfully!"

# Set proper permissions
print_status "Setting file permissions..."
chown -R www-data:www-data /var/www/pterodactyl
chmod -R 755 /var/www/pterodactyl/storage
chmod -R 755 /var/www/pterodactyl/bootstrap/cache

# Clear cache
print_status "Clearing application cache..."
cd /var/www/pterodactyl
php artisan config:cache
php artisan view:cache

echo ""
echo -e "${GREEN}==================================================${NC}"
echo -e "${GREEN}    PROTECT BY ZERO INSTALLATION COMPLETE!${NC}"
echo -e "${GREEN}            Created by ZeroHosting${NC}"
echo -e "${GREEN}==================================================${NC}"
echo ""
echo -e "${YELLOW}Summary:${NC}"
echo -e "✓ Anti Delete Server Protection"
echo -e "✓ Anti Delete User Protection" 
echo -e "✓ Anti Intip Location Protection"
echo -e "✓ Anti Intip Nodes Protection"
echo -e "✓ Anti Intip Nest Protection"
echo -e "✓ Anti Intip Settings Protection"
echo ""
echo -e "${YELLOW}Backups saved to:${NC} $BACKUP_DIR"
echo ""
echo -e "${BLUE}Your Pterodactyl panel is now protected by Zero!${NC}"
echo ""
