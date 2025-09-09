#!/usr/bin/env bash
set -euo pipefail

echo "==> Seleccionando Xcode por defecto"
/usr/bin/sudo xcode-select -s /Applications/Xcode.app

echo "==> Ejecutando configuración inicial de Xcode (si aplica)"
/usr/bin/sudo xcodebuild -runFirstLaunch || true

echo "==> Cerrando Simulator y apagando dispositivos"
killall Simulator 2>/dev/null || true
xcrun simctl shutdown all 2>/dev/null || true

echo "==> Reiniciando CoreSimulatorService"
pkill -9 com.apple.CoreSimulator.CoreSimulatorService 2>/dev/null || true
pkill -9 com.apple.CoreSimulatorService 2>/dev/null || true

echo "==> Eliminando TODOS los simuladores existentes"
# Esto borra todos los dispositivos (no borra runtimes instalados)
xcrun simctl delete all 2>/dev/null || true

echo "==> Detectando runtimes de iOS instalados"
# Listar runtimes iOS disponibles
xcrun simctl list runtimes

# Intentar preferentemente iOS 18, si no, tomar el último iOS disponible
PREFERRED_RUNTIME=$(xcrun simctl list runtimes | awk -F'[()]' '/iOS 18/ && /Available/ {print $2; exit}')
if [[ -z "${PREFERRED_RUNTIME:-}" ]]; then
  # Tomar el último runtime iOS Available de la lista
  PREFERRED_RUNTIME=$(xcrun simctl list runtimes | awk -F'[()]' '/iOS/ && /Available/ {last=$2} END{print last}')
fi

if [[ -z "${PREFERRED_RUNTIME:-}" ]]; then
  echo "✖ No se encontró ningún runtime de iOS disponible."
  echo "   Abre Xcode → Settings → Platforms y descarga un iOS Simulator runtime (iOS 18/17)."
  exit 1
fi

echo "==> Runtime elegido: $PREFERRED_RUNTIME"

# Tipos de dispositivo posibles (nuevo primero, luego fallback)
TYPE_16P="com.apple.CoreSimulator.SimDeviceType.iPhone-16-Pro"
TYPE_15P="com.apple.CoreSimulator.SimDeviceType.iPhone-15-Pro"

echo "==> Verificando tipo de dispositivo iPhone 16 Pro"
HAS_16P=$(xcrun simctl list devicetypes | grep -c "iPhone 16 Pro" || true)
DEV_TYPE="$TYPE_16P"
DEV_NAME="iPhone 16 Pro"

if [[ "$HAS_16P" -eq 0 ]]; then
  echo "   iPhone 16 Pro no disponible. Usando iPhone 15 Pro como fallback."
  DEV_TYPE="$TYPE_15P"
  DEV_NAME="iPhone 15 Pro"
fi

echo "==> Creando simulador: $DEV_NAME"
NEW_ID=$(xcrun simctl create "$DEV_NAME" "$DEV_TYPE" "$PREFERRED_RUNTIME")
if [[ -z "$NEW_ID" ]]; then
  echo "✖ No se pudo crear el simulador. Revisa que el runtime y el tipo existan."
  exit 1
fi

echo "==> Simulador creado con UDID: $NEW_ID"

echo "==> Abriendo la app Simulator"
open -a Simulator

# Espera breve para que arranque el servicio
sleep 2

echo "==> Comprobando dispositivos que Flutter ve:"
flutter devices || true

cat <<EOF

✅ Listo. Simulador creado: $DEV_NAME
   UDID: $NEW_ID

Ahora puedes ejecutar (usa el flavor EXACTO de tu scheme iOS):
  flutter run -d "$NEW_ID" --flavor "Runner-dev" -t lib/main_dev.dart

Si prefieres usar --flavor dev (sin 'Runner-'), renombra tus Schemes en Xcode a: dev, qa, prd.
EOF
