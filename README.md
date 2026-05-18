# GoodRoads

Sistema de registro de ocorrências em estradas rurais da **GRB**.

## Requisitos

- Flutter SDK ^3.11.5
- Dart ^3.11.5
- Android Studio / Xcode (mobile)
- Contas: Google Cloud (Maps), Firebase (opcional)

## Instalação

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

## Executar

```bash
# Mobile
flutter run

# Web (painel / testes)
flutter run -d chrome

# Com variáveis via arquivo .env (opcional)
cp .env.example .env
# Edite .env e adicione em pubspec.yaml:  - .env  (em flutter > assets)
flutter run
```

## Build Runner (Freezed / Json Serializable)

```bash
dart run build_runner build --delete-conflicting-outputs

# Modo watch durante desenvolvimento
dart run build_runner watch --delete-conflicting-outputs
```

## Onde adicionar API KEYS

| Serviço | Onde configurar |
|---------|-----------------|
| **Variáveis gerais** | `.env` (copie de `.env.example`) + `assets/configuracao/ambiente.padrao.env` |
| **Google Maps Android** | `android/local.properties` → `GOOGLE_MAPS_API_KEY=` |
| **Google Maps iOS** | `ios/Runner/Info.plist` → chave `GMSApiKey` |
| **Google Maps Web** | `web/index.html` → parâmetro `key=` no script do Maps |
| **Firebase Android** | `android/app/google-services.json` (veja `.example`) |
| **Firebase iOS** | `ios/Runner/GoogleService-Info.plist` (veja `.example`) |
| **Firebase Dart** | `lib/configuracao/firebase/firebase_options.dart` via `flutterfire configure` |
| **API CPF/CNPJ** | `.env` → `CPF_CNPJ_API_URL` e `CPF_CNPJ_API_TOKEN` |

### Firebase (passo a passo)

```bash
dart pub global activate flutterfire_cli
dart run flutterfire_cli:flutterfire configure
```

No `.env`, defina `FIREBASE_HABILITADO=true` após configurar.

### Google Maps (passo a passo)

1. Crie um projeto no [Google Cloud Console](https://console.cloud.google.com/)
2. Ative **Maps SDK for Android**, **iOS** e **Maps JavaScript API** (web)
3. Crie chaves de API restritas por plataforma
4. Insira nas localizações da tabela acima

## Arquitetura

- **Clean Architecture** + **Feature First**
- **Riverpod** (estado) · **GoRouter** (rotas) · **Dio** (HTTP)
- Pastas: `lib/nucleo`, `lib/compartilhado`, `lib/funcionalidades`, `lib/configuracao`

## Análise estática

```bash
flutter analyze
flutter test
```
