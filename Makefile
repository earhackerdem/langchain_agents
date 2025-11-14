.PHONY: help setup install run test clean pull-model check-ollama install-ollama list-models shell reset freeze upgrade dev setup-direnv install-direnv check-direnv

PYTHON := python3
VENV := .venv
BIN := $(VENV)/bin
OLLAMA_MODEL := $(shell grep OLLAMA_MODEL .env 2>/dev/null | cut -d '=' -f2 || echo "mistral")

help:
	@echo "Comandos disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

setup: ## Configurar proyecto completo desde cero
	@echo "🚀 =================================="
	@echo "🚀 SETUP COMPLETO DEL PROYECTO"
	@echo "🚀 =================================="
	@echo ""
	@echo "📦 [1/6] Creando entorno virtual..."
	$(PYTHON) -m venv $(VENV)
	@echo "✅ Entorno virtual creado"
	@echo ""
	@echo "📦 [2/6] Actualizando pip..."
	$(BIN)/pip install --upgrade pip -q
	@echo "✅ pip actualizado"
	@echo ""
	@echo "📦 [3/6] Instalando dependencias..."
	$(BIN)/pip install -r requirements.txt -q
	@echo "✅ Dependencias instaladas"
	@echo ""
	@echo "⚙️  [4/6] Configurando .env..."
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo "✅ .env creado desde .env.example"; \
	else \
		echo "⚠️  .env ya existe, no se sobrescribe"; \
	fi
	@echo ""
	@echo "🔍 [5/6] Verificando Ollama..."
	@if command -v ollama >/dev/null 2>&1; then \
		echo "✅ Ollama está instalado"; \
		if curl -s http://localhost:11434/api/tags >/dev/null 2>&1; then \
			echo "✅ Ollama está corriendo"; \
		else \
			echo "⚠️  Ollama instalado pero no está corriendo"; \
			echo "   Ejecuta en otra terminal: ollama serve"; \
		fi; \
	else \
		echo "❌ Ollama no está instalado"; \
		echo "   Ejecuta: make install-ollama"; \
	fi
	@echo ""
	@echo "🤖 [6/6] Verificando modelo..."
	@if command -v ollama >/dev/null 2>&1 && curl -s http://localhost:11434/api/tags >/dev/null 2>&1; then \
		if ollama list | grep -q "$(OLLAMA_MODEL)"; then \
			echo "✅ Modelo $(OLLAMA_MODEL) ya está instalado"; \
		else \
			echo "⚠️  Modelo $(OLLAMA_MODEL) no encontrado"; \
			echo "   Descarga con: make pull-model"; \
		fi; \
	fi
	@echo ""
	@echo "🎉 =================================="
	@echo "🎉 SETUP COMPLETADO"
	@echo "🎉 =================================="
	@echo ""
	@echo "📋 Siguientes pasos:"
	@echo "   1. make pull-model     (descargar modelo)"
	@echo "   2. make run            (ejecutar agente)"
	@echo "   3. make setup-direnv   (opcional: auto-activar venv)"
	@echo ""

install: ## Instalar/actualizar dependencias
	@echo "📦 Instalando dependencias..."
	$(BIN)/pip install -r requirements.txt
	@echo "✅ Dependencias instaladas"

run: ## Ejecutar el agente
	@echo "🤖 Ejecutando agente..."
	$(BIN)/python main.py

test: ## Probar conexión con Ollama
	@echo "🧪 Probando conexión con Ollama..."
	$(BIN)/python test_ollama.py

check-ollama: ## Verificar Ollama
	@echo "🔍 Verificando Ollama..."
	@if command -v ollama >/dev/null 2>&1; then \
		echo "✅ Ollama está instalado"; \
		if curl -s http://localhost:11434/api/tags >/dev/null 2>&1; then \
			echo "✅ Ollama está corriendo"; \
			ollama list; \
		else \
			echo "⚠️  Ollama instalado pero no está corriendo"; \
			echo "   Ejecuta: ollama serve"; \
		fi; \
	else \
		echo "❌ Ollama no está instalado"; \
		echo "   Ejecuta: make install-ollama"; \
	fi

install-ollama: ## Instalar Ollama
	@echo "📥 Instalando Ollama..."
	curl -fsSL https://ollama.com/install.sh | sh
	@echo "✅ Ollama instalado"

pull-model: ## Descargar modelo configurado en .env
	@echo "📥 Descargando modelo: $(OLLAMA_MODEL)"
	ollama pull $(OLLAMA_MODEL)
	@echo "✅ Modelo $(OLLAMA_MODEL) descargado"

list-models: ## Listar modelos instalados
	@ollama list

pull-mistral: ## Descargar Mistral 7B
	@ollama pull mistral

pull-llama: ## Descargar Llama 3.1 8B
	@ollama pull llama3.1:8b

pull-qwen: ## Descargar Qwen 2.5 14B
	@ollama pull qwen2.5:14b

pull-deepseek: ## Descargar DeepSeek Coder
	@ollama pull deepseek-coder:6.7b

shell: ## Abrir shell con venv activado
	@echo "🐚 Abriendo shell con venv activado..."
	@$(BIN)/python -c "import sys; print(f'Python: {sys.version}')"
	@bash --init-file <(echo ". $(HOME)/.bashrc; source $(BIN)/activate; PS1='(venv) \u@\h:\w\$$ '")

clean: ## Limpiar archivos temporales
	@echo "🧹 Limpiando archivos temporales..."
	@find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	@find . -type f -name "*.pyc" -delete 2>/dev/null || true
	@find . -type f -name "*.pyo" -delete 2>/dev/null || true
	@find . -type f -name "*.log" -delete 2>/dev/null || true
	@echo "✅ Limpieza completada"

reset: clean ## Reset completo (eliminar venv y reinstalar)
	@echo "🔄 Eliminando entorno virtual..."
	@rm -rf $(VENV)
	@echo "🚀 Reinstalando..."
	@make setup

freeze: ## Guardar dependencias actuales
	@$(BIN)/pip freeze > requirements.txt
	@echo "✅ requirements.txt actualizado"

upgrade: ## Actualizar todas las dependencias
	@$(BIN)/pip install --upgrade -r requirements.txt
	@echo "✅ Dependencias actualizadas"

setup-direnv: ## Configurar direnv para auto-activar venv
	@echo "🔧 Configurando direnv..."
	@if ! command -v direnv >/dev/null 2>&1; then \
		echo "❌ direnv no está instalado"; \
		echo ""; \
		echo "Opciones:"; \
		echo "  1. Instalar automáticamente: make install-direnv"; \
		echo "  2. Instalar manualmente:"; \
		echo "     - Ubuntu/Debian: sudo apt install direnv"; \
		echo "     - Mac: brew install direnv"; \
		echo ""; \
		exit 1; \
	fi
	@echo "✅ direnv detectado"
	@echo ""
	@echo "📝 Creando .envrc..."
	@echo 'source .venv/bin/activate' > .envrc
	@echo "✅ .envrc creado"
	@echo ""
	@echo "🔐 Autorizando .envrc..."
	@direnv allow .
	@echo "✅ direnv configurado"
	@echo ""
	@echo "🎉 Configuración completa!"
	@echo ""
	@echo "⚠️  IMPORTANTE: Configura tu shell (si no lo has hecho):"
	@echo "   bash:  echo 'eval \"\$$(direnv hook bash)\"' >> ~/.bashrc && source ~/.bashrc"
	@echo "   zsh:   echo 'eval \"\$$(direnv hook zsh)\"' >> ~/.zshrc && source ~/.zshrc"
	@echo ""
	@echo "Después de configurar tu shell, al entrar a este directorio"
	@echo "el venv se activará automáticamente ✨"

install-direnv: ## Instalar direnv en el sistema
	@echo "📥 Instalando direnv..."
	@if command -v apt-get >/dev/null 2>&1; then \
		echo "Detectado: Ubuntu/Debian"; \
		sudo apt-get update && sudo apt-get install -y direnv; \
	elif command -v brew >/dev/null 2>&1; then \
		echo "Detectado: macOS (Homebrew)"; \
		brew install direnv; \
	elif command -v dnf >/dev/null 2>&1; then \
		echo "Detectado: Fedora/RHEL"; \
		sudo dnf install -y direnv; \
	else \
		echo "❌ No se pudo detectar el gestor de paquetes"; \
		echo "Instala direnv manualmente: https://direnv.net/docs/installation.html"; \
		exit 1; \
	fi
	@echo ""
	@echo "✅ direnv instalado"
	@echo ""
	@echo "Ahora ejecuta: make setup-direnv"

check-direnv: ## Verificar configuración de direnv
	@echo "🔍 Verificando direnv..."
	@if command -v direnv >/dev/null 2>&1; then \
		echo "✅ direnv está instalado: $$(direnv version)"; \
		if [ -f .envrc ]; then \
			echo "✅ .envrc existe en el proyecto"; \
		else \
			echo "⚠️  .envrc no existe. Ejecuta: make setup-direnv"; \
		fi; \
		if grep -q "direnv hook" ~/.zshrc 2>/dev/null || grep -q "direnv hook" ~/.bashrc 2>/dev/null; then \
			echo "✅ Hook de direnv configurado en shell"; \
		else \
			echo "⚠️  Hook de direnv no configurado en shell"; \
			echo "   Añade a tu ~/.zshrc o ~/.bashrc:"; \
			echo "   eval \"\$$(direnv hook zsh)\"  # para zsh"; \
			echo "   eval \"\$$(direnv hook bash)\" # para bash"; \
		fi; \
	else \
		echo "❌ direnv no está instalado"; \
		echo "   Ejecuta: make install-direnv"; \
	fi

