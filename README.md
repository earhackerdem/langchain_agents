# My Course Agent

Agente de IA usando LangChain con soporte para Ollama, OpenAI y Anthropic.

## Requisitos

- Python 3.12+
- Ollama (para modelos locales)

## Instalación

### 1. Instalar Ollama

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

### 2. Descargar un modelo

```bash
ollama pull mistral
```

Modelos recomendados:
- `mistral` - 7B, excelente para español
- `llama3.2` - 3B, rápido
- `llama3.1:8b` - 8B, mayor capacidad
- `qwen2.5:14b` - 14B, máxima calidad

### 3. Configurar el proyecto

```bash
# Crear entorno virtual
python -m venv .venv

# Activar entorno virtual
source .venv/bin/activate

# Instalar dependencias
pip install -r requirements.txt

# Configurar variables de entorno
cp .env.example .env
```

Editar `.env` y configurar el modelo:

```bash
OLLAMA_MODEL=mistral
```

## Uso

```bash
source .venv/bin/activate
python main.py
```

## Configuración

### Usar OpenAI

1. Obtener API key en https://platform.openai.com/api-keys
2. Añadir en `.env`:
   ```
   OPENAI_API_KEY=tu-api-key
   ```
3. Cambiar en `main.py`:
   ```python
   MODEL_TYPE = "openai"
   ```

### Usar Anthropic

1. Obtener API key en https://console.anthropic.com/
2. Añadir en `.env`:
   ```
   ANTHROPIC_API_KEY=tu-api-key
   ```
3. Cambiar en `main.py`:
   ```python
   MODEL_TYPE = "anthropic"
   ```

## Estructura

```
my_course_agent/
├── main.py              # Código principal
├── test_ollama.py       # Script de pruebas
├── requirements.txt     # Dependencias
├── .env                 # Configuración
└── README.md           # Documentación
```
