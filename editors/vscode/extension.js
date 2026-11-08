const path = require('path');
const fs = require('fs');
const vscode = require('vscode');
const { LanguageClient, TransportKind } = require('vscode-languageclient/node');

let client;

function resolveServerPath() {
    const config = vscode.workspace.getConfiguration('theflux');
    const configuredPath = config.get('lsp.serverPath', 'fluxlsp');

    // 1. Verifica bin/fluxlsp no diretorio raiz do workspace aberto
    if (vscode.workspace.workspaceFolders && vscode.workspace.workspaceFolders.length > 0) {
        const rootPath = vscode.workspace.workspaceFolders[0].uri.fsPath;
        const candidateWin = path.join(rootPath, 'bin', 'fluxlsp.exe');
        const candidateUnix = path.join(rootPath, 'bin', 'fluxlsp');
        if (process.platform === 'win32' && fs.existsSync(candidateWin)) {
            return candidateWin;
        }
        if (fs.existsSync(candidateUnix)) {
            return candidateUnix;
        }
    }

    return configuredPath;
}

function activate(context) {
    const serverExe = resolveServerPath();
    const serverOptions = {
        command: serverExe,
        args: [],
        transport: TransportKind.stdio
    };

    const clientOptions = {
        documentSelector: [
            { scheme: 'file', language: 'flux' }
        ],
        synchronize: {
            fileEvents: vscode.workspace.createFileSystemWatcher('**/*.{flux,fdsl}')
        }
    };

    client = new LanguageClient(
        'thefluxLanguageServer',
        'TheFlux Language Server (fluxlsp)',
        serverOptions,
        clientOptions
    );

    client.start();
}

function deactivate() {
    if (!client) {
        return undefined;
    }
    return client.stop();
}

module.exports = {
    activate,
    deactivate
};
