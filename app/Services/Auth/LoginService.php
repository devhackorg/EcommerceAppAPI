<?php

namespace App\Services\Auth;

class LoginService
{
    public function execute(array $credentials)
    {
        try {
            if (!auth()->attempt($credentials)) {
                throw new \Exception("Credenciais inválidas!", 401);
            }

            /** @var \App\Models\User $user **/
            $user = auth()->user();
            $accessToken = $user->createToken("auth_token")->plainTextToken;

            $response =  [
                "access_token" => $accessToken,
                "token_type" => 'Bearer'
            ];

            return $response;
        } catch (\Exception $e) {
            throw $e;
        }
    }
}
