import { $, cd, glob, path, argv } from 'zx';
import { fileURLToPath } from 'url';

const isUpgrade = argv.upgrade || false;

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

(async () => {
  const basePath = path.resolve(__dirname, '..');
  const files = await glob(`${basePath}/**/pubspec.yaml`);
  for (let file of files) {
    await installPackages(path.dirname(file));
  }
})();

async function installPackages(path) {
  cd(path);

  await $`flutter pub ${isUpgrade ? 'upgrade' : 'get'}`;
}
