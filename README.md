# Calculadora Científica — Flutter

Projeto escolar desenvolvido em Flutter/Dart.

## Funcionalidades

- Adição, subtração, multiplicação e divisão.
- Raiz quadrada, potência e porcentagem.
- Botões para limpar, apagar o último caractere e trocar o sinal.
- Conversão do visor (`String`) para `double`.
- Estruturas condicionais `if/else` e `switch`.
- Validação de divisão por zero e de raiz quadrada de número negativo.
- Interface adaptável para navegador e dispositivos móveis.

## Executar no computador

É necessário instalar o Flutter SDK e configurar o ambiente:
https://docs.flutter.dev/get-started/install

No terminal, dentro desta pasta:

```bash
flutter pub get
flutter run -d chrome
```

Para executar no emulador ou celular, use `flutter run` com um dispositivo conectado.

## Publicar no GitHub Pages

O repositório contém uma GitHub Action em `.github/workflows/deploy.yml` que compila o aplicativo Flutter para Web e publica o resultado automaticamente.

1. Crie um repositório no GitHub chamado `calculadora_cientifica` (ou outro nome).
2. Envie todos os arquivos deste projeto para a branch `main`.
3. No GitHub, abra **Settings → Pages**.
4. Em **Build and deployment → Source**, selecione **GitHub Actions**.
5. Abra a aba **Actions** e espere o fluxo “Publicar calculadora no GitHub Pages” terminar com sucesso.
6. A URL publicada aparecerá no trabalho concluído e em **Settings → Pages**.

O endereço normalmente será `https://SEU-USUARIO.github.io/NOME-DO-REPOSITORIO/`.

## Observação

O repositório contém o código-fonte Flutter. A GitHub Action gera a versão Web automaticamente; não é necessário compilar o aplicativo no computador antes de enviá-lo ao GitHub.
