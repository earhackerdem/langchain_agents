# Changelog

## [Refactor] - 2025-01-14

### Changed
- **BREAKING:** Renombrado `MODEL_TYPE` → `MODEL_PROVIDER` para mayor claridad semántica
- El código ahora usa `MODEL_PROVIDER` en `.env` para especificar el backend
- Parámetro de función cambiado de `model_type` a `provider`

### Added
- Soporte para **LM Studio** como proveedor local adicional
- Variables de entorno específicas por proveedor:
  - `LMSTUDIO_MODEL` para LM Studio
  - `OPENAI_MODEL` para personalizar modelo de OpenAI
  - `ANTHROPIC_MODEL` para personalizar modelo de Anthropic
- `MODEL_PROVIDER` ahora se lee del `.env` (puede ser: ollama, lmstudio, openai, anthropic)
- Documentación completa de LM Studio en README

### Migration Guide

Si tienes código existente:

```python
# Antes
MODEL_TYPE = "ollama"
model = get_model(MODEL_TYPE)

# Después
MODEL_PROVIDER = "ollama"
model = get_model(MODEL_PROVIDER)
```

En tu `.env`:
```bash
# Antes
OLLAMA_MODEL=mistral

# Después
MODEL_PROVIDER=ollama
OLLAMA_MODEL=mistral
```

El código es retrocompatible: si no defines `MODEL_PROVIDER` en `.env`, usa "ollama" por defecto.

