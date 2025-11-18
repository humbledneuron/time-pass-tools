#!/bin/bash

set -e

# CONFIGURATION
APP_NAME="whatsapp-desktop"
APP_DIR="$HOME/$APP_NAME"
ICON_URL="https://upload.wikimedia.org/wikipedia/commons/6/6b/WhatsApp.svg"
ICON_NAME="icon.png"
MAIN_JS="$APP_DIR/main.js"
PACKAGE_JSON="$APP_DIR/package.json"
DESKTOP_FILE="$HOME/.local/share/applications/whatsapp-desktop.desktop"

echo "🔧 Setting up $APP_NAME in $APP_DIR"

# 1. Install Node.js & npm if not already
if ! command -v node >/dev/null || ! command -v npm >/dev/null; then
    echo "📦 Installing Node.js and npm..."
    sudo apt update
    sudo apt install -y nodejs npm
fi

# 2. Create app directory
mkdir -p "$APP_DIR/assets"

# 3. Download WhatsApp icon
echo "🖼️ Downloading icon..."
wget -O "$APP_DIR/assets/$ICON_NAME" "$ICON_URL"

# 4. Create main.js
echo "📄 Creating main.js..."
cat <<EOF > "$MAIN_JS"
const { app, BrowserWindow, Tray, Menu } = require('electron');
const path = require('path');

let win;
let tray = null;

function createWindow() {
  win = new BrowserWindow({
    width: 1000,
    height: 800,
    icon: path.join(__dirname, 'assets', '$ICON_NAME'),
    webPreferences: {
      nodeIntegration: true,
    }
  });

  win.loadURL('https://web.whatsapp.com');

  win.on('minimize', function (event) {
    event.preventDefault();
    win.hide();
  });

  win.on('close', function (event) {
    if (!app.isQuiting) {
      event.preventDefault();
      win.hide();
    }
  });
}

app.whenReady().then(() => {
  createWindow();

  tray = new Tray(path.join(__dirname, 'assets', '$ICON_NAME'));
  const contextMenu = Menu.buildFromTemplate([
    { label: 'Show WhatsApp', click: () => win.show() },
    { label: 'Quit', click: () => {
      app.isQuiting = true;
      app.quit();
    }}
  ]);
  tray.setToolTip('WhatsApp Desktop');
  tray.setContextMenu(contextMenu);
  tray.on('click', () => {
    win.isVisible() ? win.hide() : win.show();
  });
});
EOF

# 5. Create package.json
echo "📦 Creating package.json..."
cat <<EOF > "$PACKAGE_JSON"
{
  "name": "$APP_NAME",
  "version": "1.0.0",
  "description": "Unofficial WhatsApp Web wrapper",
  "main": "main.js",
  "scripts": {
    "start": "electron .",
    "build": "electron-builder"
  },
  "build": {
    "appId": "com.example.$APP_NAME",
    "productName": "WhatsApp Desktop",
    "linux": {
      "target": ["AppImage", "deb"],
      "icon": "assets/$ICON_NAME",
      "category": "Network"
    }
  },
  "dependencies": {
    "electron": "^28.1.0"
  },
  "devDependencies": {
    "electron-builder": "^24.13.1"
  }
}
EOF

# 6. Install npm packages
echo "📥 Installing npm dependencies..."
cd "$APP_DIR"
npm install

# 7. Create .desktop launcher
echo "🚀 Creating launcher..."
cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Name=WhatsApp Desktop
Comment=Unofficial WhatsApp Web wrapper
Exec=npm start --prefix $APP_DIR
Icon=$APP_DIR/assets/$ICON_NAME
Terminal=false
Type=Application
Categories=Network;Chat;
StartupNotify=true
EOF

chmod +x "$DESKTOP_FILE"

# 8. Optional: Build AppImage and deb
echo "🔧 Building .AppImage and .deb packages..."
npm run build

# 9. Done
echo "✅ Done! You can now run 'WhatsApp Desktop' from your applications menu."
