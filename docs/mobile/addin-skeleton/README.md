# Скелет Android-компоненты Google Sign-In

Это **заготовка для разработки**, не готовый бинарник. Реализация — по технологии внешних компонент 1С (Native API + JNI/Java).

## Минимальный публичный API (для 1С)

```text
SignIn()     — показать системный выбор Google-аккаунта
SignOut()    — выйти из аккаунта в Google Play Services
IsSupported() — true на Android с Play Services
```

## События в 1С

| Событие | Данные |
|---------|--------|
| `GoogleSignInSuccess` | JSON-строка: email, accessToken, refreshToken, expiresIn |
| `GoogleSignInCancel` | пусто или причина |
| `GoogleSignInError` | текст ошибки |

## Рекомендуемый стек

- Google Identity / Credential Manager или `play-services-auth`
- Scope Drive: `https://www.googleapis.com/auth/drive.file`
- Package name = как в сборщике МП
- SHA-1 debug/release в Google Cloud Console

## Пакет результата для сборщика

ZIP внешней компоненты со структурой по документации 1С (варианты Android armeabi-v7a / arm64-v8a и т.д.).  
После сборки ZIP → макет `ОбщийМакет.WalletGoogleSignIn` в конфигурации.

## Не делать в компоненте

- Не хранить и не запрашивать пароль Google
- Не логировать access/refresh token в logcat в release
