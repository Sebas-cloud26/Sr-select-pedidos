# SR Select Pedidos

Código fuente del artefacto **SR Select Pedidos** (https://claude.ai/artifact/GqaFxEgHcaNuLTPfU9fY9Q).

- `index.html`: la página completa (HTML + CSS + JS en un solo archivo).
- Los datos (pedidos, clientes, gastos, fotos) **no viven aquí**: están en la base de datos y el almacén de archivos del artefacto (`window.claude.use` con las capacidades `db`, `assets` y `user`).

## Flujo de trabajo
1. Editar `index.html` en Claude Code.
2. Republicar al mismo URL del artefacto (los datos se conservan).
3. Hacer commit y push para guardar el historial de cambios.
