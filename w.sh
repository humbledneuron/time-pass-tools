#!/bin/bash

APP_NAME="whatsapp-desktop"
APP_DIR="$HOME/$APP_NAME"
ICON_URL="https://upload.wikimedia.org/wikipedia/commons/5/5e/WhatsApp_icon.png"
ICON_LOCAL="$APP_DIR/icon.png"
DESKTOP_ENTRY_PATH="$HOME/.local/share/applications/whatsapp.desktop"
ICON_TARGET="$HOME/.local/share/icons/whatsapp.png"

# Step 1: Create and enter project folder
echo "[1/8] Creating project directory at $APP_DIR..."
mkdir -p "$APP_DIR"
cd "$APP_DIR" || exit 1

# Step 2: Initialize npm
echo "[2/8] Initializing npm..."
npm init -y > /dev/null

# Step 3: Install Electron
echo "[3/8] Installing Electron..."
npm install --save-dev electron > /dev/null

# Step 4: Download WhatsApp icon
echo "[4/8] Downloading WhatsApp icon..."
wget -q "$ICON_URL" -O "$ICON_LOCAL"

# Step 5: Create main.js (Electron entry point)
echo "[5/8] Creating main.js..."
cat <<EOF > main.js
const { app, BrowserWindow } = require('electron')

function createWindow() {
  const win = new BrowserWindow({
    width: 1200,
    height: 800,
    webPreferences: {
      contextIsolation: true,
      nodeIntegration: false
    },
    icon: __dirname + '/icon.png'
  })

  win.loadURL('https://web.whatsapp.com')
}

app.whenReady().then(createWindow)

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit()
})
EOF

# Step 6: Update package.json start script
echo "[6/8] Updating package.json start script..."
npx json -I -f package.json -e 'this.scripts.start="electron main.js"' 2>/dev/null || {
  echo "Installing 'json' tool..."
  npm install -g json
  npx json -I -f package.json -e 'this.scripts.start="electron main.js"'
}

# Step 7: Copy icon to system icon directory
echo "[7/8] Copying icon to user icon folder..."
mkdir -p "$(dirname "$ICON_TARGET")"
cp "$ICON_LOCAL" "$ICON_TARGET"

# Step 8: Create Linux .desktop launcher
echo "[8/8] Creating desktop shortcut..."
cat <<EOF > "$DESKTOP_ENTRY_PATH"
[Desktop Entry]
Name=WhatsApp Desktop
Comment=Unofficial WhatsApp Web wrapper
Exec=npm start --prefix $APP_DIR
Icon=whatsapp
Terminal=false
Type=Application
Categories=Network;Chat;
EOF

chmod +x "$DESKTOP_ENTRY_PATH"

# Final message
echo "✅ WhatsApp Desktop created successfully!"
echo "➡️ To run now: cd \"$APP_DIR\" && npm start"
echo "🖥️ A desktop shortcut was created at: $DESKTOP_ENTRY_PATH"

