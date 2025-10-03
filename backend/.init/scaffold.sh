#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="/home/kavia/workspace/code-generation/bookstore-online-platform-146925-146936/backend"
mkdir -p "$WORKSPACE" && cd "$WORKSPACE"
# Initialize npm if missing
if [ ! -f package.json ]; then npm init -y >/dev/null 2>&1; node -e "let p=require('./package.json');p.name=p.name||'backend';p.version=p.version||'0.1.0';require('fs').writeFileSync('package.json',JSON.stringify(p,null,2));"; fi
# Add example index.js if missing
if [ ! -f "$WORKSPACE/index.js" ]; then
  cat > "$WORKSPACE/index.js" <<'NODEAPP'
const express = require('express');
const dotenv = require('dotenv');
dotenv.config();
const app = express();
app.use(express.json());
const PORT = process.env.PORT || 3000;
let books = [{id:1,title:'Example Book'}];
let orders = [];
app.get('/books', (req,res)=>res.json(books));
app.post('/books',(req,res)=>{const b={id:books.length+1,...req.body};books.push(b);res.status(201).json(b)});
app.get('/orders',(req,res)=>res.json(orders));
app.post('/orders',(req,res)=>{const o={id:orders.length+1,...req.body};orders.push(o);res.status(201).json(o)});
if (require.main === module) app.listen(PORT,()=>console.log(`listening ${PORT}`));
module.exports = app;
NODEAPP
fi
# .env only if missing
if [ ! -f "$WORKSPACE/.env" ]; then cat > "$WORKSPACE/.env" <<'ENV'
PORT=3000
NODE_ENV=development
ENV
fi
# .dockerignore safe defaults (overwrite)
cat > "$WORKSPACE/.dockerignore" <<'DOCKER'
node_modules
npm-debug.log
coverage
.DS_Store
DOCKER

# .gitignore: create only if missing to avoid overwriting developer files
if [ ! -f "$WORKSPACE/.gitignore" ]; then cat > "$WORKSPACE/.gitignore" <<'GIT'
node_modules
.env
coverage
GIT
fi
# Add minimal README if missing
if [ ! -f "$WORKSPACE/README.md" ]; then cat > "$WORKSPACE/README.md" <<'MD'
# Backend (Express)

Run: npm start
Dev: npm run dev
Test: npm test
Logs: /tmp/test_run.log, /tmp/backend_start.log
MD
fi
# Attempt to make files readable and directories accessible; may require sudo in some environments
chmod -R a+rX "$WORKSPACE" || echo "Warning: chmod failed; permissions may remain unchanged. Run with sudo if required."
