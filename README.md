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

Consulta la [guía de modelos](#guía-de-modelos-por-hardware) para elegir el mejor según tu hardware.

### 3. Configurar el proyecto

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
```

Editar `.env` con el modelo elegido:

```bash
OLLAMA_MODEL=mistral
```

## Uso

```bash
source .venv/bin/activate
python main.py
```

## Guía de Modelos por Hardware

### GPU NVIDIA

| GPU | VRAM | Modelo Inicial | Modelo Avanzado | Modelo Premium |
|-----|------|----------------|-----------------|----------------|
| RTX 4060 | 8GB | `mistral:7b` | `llama3.1:8b` | - |
| RTX 4070 | 12GB | `mistral:7b` | `qwen2.5:14b` | `llama3.1:13b` |
| RTX 4080/5080 | 16GB | `qwen2.5:14b` | `llama3.1:13b` | `mixtral:8x7b-q4` |
| RTX 4090 | 24GB | `mixtral:8x7b` | `llama3.1:70b-q4` | `qwen2.5:32b` |

### Apple Silicon

| Chip | RAM Unificada | Modelo Inicial | Modelo Avanzado | Modelo Premium |
|------|---------------|----------------|-----------------|----------------|
| M1/M2 | 8GB | `llama3.2:3b` | `mistral:7b` | - |
| M1/M2 | 16GB | `mistral:7b` | `llama3.1:8b` | - |
| M1/M2 Pro/Max | 32GB | `qwen2.5:14b` | `llama3.1:13b` | `mixtral:8x7b` |
| M1/M2 Ultra | 64GB+ | `mixtral:8x7b` | `llama3.1:70b-q4` | `qwen2.5:72b` |

**Nota:** En Apple Silicon, la RAM unificada se comparte entre CPU y GPU.

### Características de los Modelos

| Modelo | Parámetros | VRAM | Velocidad | Calidad | Mejor para |
|--------|-----------|------|-----------|---------|------------|
| `llama3.2:3b` | 3B | ~2GB | ⚡⚡⚡⚡⚡ | ⭐⭐⭐ | Pruebas rápidas |
| `mistral:7b` | 7B | ~4GB | ⚡⚡⚡⚡ | ⭐⭐⭐⭐ | Uso general |
| `llama3.1:8b` | 8B | ~5GB | ⚡⚡⚡⚡ | ⭐⭐⭐⭐ | Desarrollo |
| `qwen2.5:14b` | 14B | ~9GB | ⚡⚡⚡ | ⭐⭐⭐⭐⭐ | Calidad profesional |
| `llama3.1:13b` | 13B | ~8GB | ⚡⚡⚡ | ⭐⭐⭐⭐⭐ | Balance óptimo |
| `mixtral:8x7b` | 47B | ~26GB | ⚡⚡ | ⭐⭐⭐⭐⭐ | Máxima calidad |
| `deepseek-coder:6.7b` | 6.7B | ~4GB | ⚡⚡⚡⚡ | ⭐⭐⭐⭐ | Programación |

### Modelos por Especialidad

- **Español:** `mistral:7b`
- **Programación:** `deepseek-coder:6.7b`, `codellama:13b`
- **Razonamiento:** `qwen2.5:14b`, `llama3.1:13b`
- **Velocidad:** `llama3.2:3b`, `phi3:mini`

## Configuración Alternativa

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
