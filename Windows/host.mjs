import http from "node:http";
import { readFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

const here = path.dirname(fileURLToPath(import.meta.url));
const port = Number(process.env.PREPNEXUS_WINDOWS_PORT || 4173);
if (!Number.isInteger(port) || port < 1 || port > 65535) throw new Error("Invalid client port");
const files = new Map([
  ["/", ["index.html", "text/html; charset=utf-8"]],
  ["/app.mjs", ["app.mjs", "text/javascript; charset=utf-8"]],
  ["/client-core.mjs", ["client-core.mjs", "text/javascript; charset=utf-8"]],
  ["/styles.css", ["styles.css", "text/css; charset=utf-8"]],
  ["/catalog.json", ["../Android/app/src/main/assets/exam_catalog.json", "application/json; charset=utf-8"]]
]);

const server = http.createServer(async (request, response) => {
  const host = String(request.headers.host || "").toLowerCase();
  if (host !== `127.0.0.1:${port}` && host !== `localhost:${port}`) {
    response.writeHead(403).end();
    return;
  }
  const entry = request.method === "GET" ? files.get(new URL(request.url, "http://localhost").pathname) : null;
  if (!entry) {
    response.writeHead(404).end();
    return;
  }
  try {
    const body = await readFile(path.join(here, entry[0]));
    response.writeHead(200, {
      "Content-Type": entry[1],
      "Cache-Control": "no-store",
      "X-Content-Type-Options": "nosniff",
      "X-Frame-Options": "DENY",
      "Content-Security-Policy": "default-src 'self'; script-src 'self'; style-src 'self'; connect-src 'self' https: http://127.0.0.1:* http://localhost:*; img-src 'self'; object-src 'none'; base-uri 'none'; form-action 'none'; frame-ancestors 'none'"
    }).end(body);
  } catch {
    response.writeHead(500).end();
  }
});

server.listen(port, "127.0.0.1", () => {
  console.log(`PrepNexus Windows client: http://127.0.0.1:${port}`);
});
