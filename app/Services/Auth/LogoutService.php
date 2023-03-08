<?php

namespace App\Services\Auth;

class LogoutService
{
    public function execute()
    {
        try {
            /** @var \App\Models\User $authUser **/
            $authUser = auth()->user();
            $authUser->currentAccessToken()->delete();
        } catch (\Exception $e) {
            throw $e;
        }
    }
}
