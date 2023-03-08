<?php

namespace App\Traits;

trait JsonResponse
{
    public function ok(mixed $response)
    {
        return response()->json($response, 200);
    }

    public function created()
    {
        return response()->json(null, 201);
    }

    public function fail(string|\Exception $error)
    {
        $message = "Unknown error";
        $code = 500;

        if ($error instanceof \Exception) {
            $message =  $error->getMessage();
            if (!empty($error->getCode())) $code = $error->getCode();
        } else {
            $message = $error;
        }

        return response()->json([
            'message' => $message
        ], $code);
    }
}
