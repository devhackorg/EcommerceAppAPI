<?php

namespace App\Http\Controllers\Auth;

use App\Http\Requests\Auth\LoginRequest;
use App\Services\Auth\LoginService;
use App\Traits\JsonResponse;

class LoginController
{
    use JsonResponse;

    public function __invoke(LoginRequest $request, LoginService $service)
    {
        try {
            $response =  $service->execute($request->all());
            return $this->ok($response);
        } catch (\Exception $error) {
            return $this->fail($error);
        }
    }
}
