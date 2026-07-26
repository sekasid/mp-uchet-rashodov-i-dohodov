# Внешняя компонента WalletGoogleSignIn

Цель: нативный UX Android — кнопка **G** → системный выбор Google-аккаунта / «Войти в другой аккаунт».

Платформа 1С сама этого не умеет. Нужна внешняя компонента (Native API + Java/Android) в сборке **мобильного приложения**.

## Данные приложения (для Google Cloud)

| Параметр | Значение |
|----------|----------|
| Package name | `com.gmail.sekasid.mapp_wallet` |
| SHA-1 подписи APK | `54:42:70:63:49:7F:D7:53:BB:F8:74:F9:BD:7D:48:38:A0:92:B2:47` |
| OAuth Client ID (Device / TV) | хранится в константе `GoogleOAuthClientId` (вводится в приложении) |
| OAuth Client Secret | хранится в константе `GoogleOAuthClientSecret` (вводится в приложении) |
| APK (пример) | `E:\Базы 1С\МП Кошелек (Backup)\com.gmail.sekasid.mapp_wallet-arm64.apk` |

Client ID / Secret **не** коммитятся в репозиторий — только в константы ИБ.  
Для **Device Code** (браузерный вход без компоненты) нужен отдельный клиент типа **«ТВ и устройства с ограниченным вводом»** — Android-клиент для этого потока часто не подходит.  
В Google Cloud Console создать OAuth client типа **Android** с этим package + SHA-1.  
Приватный ключ `.pfx` в репозиторий и в чат **не класть**.


| Часть | Статус |
|-------|--------|
| UI кнопки Google на форме бэкапа | готово |
| Модуль `ОбщийМодульКлиент_GoogleSignIn` | готово (контракт) |
| `ОбработкаВнешнегоСобытия` в модуле приложения | готово |
| Сохранение email/токенов в константы | готово |
| Макет `ОбщийМакет.WalletGoogleSignIn` | **ещё нет** (добавить после сборки `.zip` компоненты) |
| Java/Android реализация | **ещё нет** |

Пока компоненты нет, кнопка «Войти через Google» сообщает об этом и предлагает запасной вход (код в браузере).

## Имена (контракт)

| Параметр | Значение |
|----------|----------|
| Макет конфигурации | `ОбщийМакет.WalletGoogleSignIn` |
| Объект после подключения | `AddIn.WalletGoogleSignIn.GoogleSignIn` |
| Методы | `SignIn()`, `SignOut()`, опционально `IsSupported()` |
| События | `GoogleSignInSuccess`, `GoogleSignInCancel`, `GoogleSignInError` |

### JSON успеха (`GoogleSignInSuccess`)

```json
{
  "email": "user@gmail.com",
  "accessToken": "...",
  "refreshToken": "...",
  "expiresIn": 3600
}
```

Пароль **не** передавать.

## Что должна делать Android-часть

1. По `SignIn()` открыть стандартный Google Sign-In / Credential Manager / AccountPicker.
2. Запросить scopes минимум:
   - `email` / `openid`
   - `https://www.googleapis.com/auth/drive.file` (для бэкапа в Drive)
3. Вернуть access token (и refresh / serverAuthCode при возможности).
4. По `SignOut()` очистить сессию Google на устройстве.
5. При отмене пользователя — событие `GoogleSignInCancel`.

Регистрация в Google Cloud:

- OAuth client типа **Android** (package name + SHA-1 подписи APK)
- при необходимости Web client ID для `requestIdToken` / server auth code
- включить **Google Drive API**

## Как встроить в конфигурацию (после готового ZIP)

1. В EDT: общий макет типа **Внешняя компонента**, имя `WalletGoogleSignIn`.
2. Загрузить ZIP с вариантами Android (`.apk` / `.so` по документации ТВК).
3. В `ОбщийМодульКлиент_GoogleSignIn.ПодключитьКомпоненту()` раскомментировать:

```bsl
Возврат ПодключитьВнешнююКомпоненту(ИмяМакетаКомпоненты());
```

4. Пересобрать мобильное приложение в сборщике МП.

## Связь с 1С

```
Форма «Резервное копирование»
  → ОбщийМодульКлиент_GoogleSignIn.НачатьНативныйВход()
  → компонента.SignIn()
  → Android picker
  → ВнешнееСобытие → ManagedApplicationModule.ОбработкаВнешнегоСобытия
  → СохранитьРезультатНативногоВхода (сервер)
  → Оповестить("WalletGoogleSignIn") → обновление формы
```

## Скелет Java (ориентир)

См. [`addin-skeleton/README.md`](addin-skeleton/README.md).
