# dogvape

Personal fork of the Voidware Roblox client, branded as **dogvape**.

## Source

[IlIllIllIIIIIIII/dogvapev2](https://github.com/IlIllIllIIIIIIII/dogvapev2)

## Development

The menu and HUD use native text wordmarks so branding does not depend on upstream Roblox logo assets. Legacy `Vape`/`Voidware` Lua API names, protocol markers, and profile formats remain for compatibility. The local cache directory remains `vape`.

`NewMainScript.lua` loads this fork. Set `shared.VapeDeveloper = true` to use files you have copied into the executor's `vape` directory. Local files in this checkout are not automatically visible to the executor.

Runtime compatibility with current Roblox, BedWars, and Opiumware has not been verified. Some inherited modules are obfuscated or contact third-party services; changing branding is not a security audit.

## Attribution

Voidware https://github.com/VapeVoidware/vapevoidware

Original authorship and the upstream [LICENSE](LICENSE) are retained. The dogvape name identifies this fork, not authorship of the original project.
