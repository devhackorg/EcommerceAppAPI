<?php

namespace App\Http\Controllers\Auth;

use App\Services\Auth\LogoutService;
use App\Traits\JsonResponse;

class LogoutController
{
    use JsonResponse;

    public function __invoke(LogoutService $service)
    {
        try {
            $service->execute();
            return $this->ok(null);
        } catch (\Exception $error) {
            return $this->fail($error);
        }
    }
}
