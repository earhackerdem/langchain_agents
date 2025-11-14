#!/usr/bin/env python3
"""
Script para probar diferentes proveedores sin modificar main.py
"""

import os
from dotenv import load_dotenv

load_dotenv()

def test_provider_selection():
    """Muestra cómo funciona la selección de proveedor"""
    
    provider = os.getenv("MODEL_PROVIDER", "ollama")
    
    print("=" * 60)
    print("🧪 TEST DE SELECCIÓN DE PROVEEDOR")
    print("=" * 60)
    print()
    print(f"📋 Proveedor configurado en .env: {provider}")
    print()
    
    if provider == "ollama":
        model = os.getenv("OLLAMA_MODEL", "gpt-oss:20b")
        print(f"🦙 Ollama")
        print(f"   Modelo: {model}")
        print(f"   URL: http://localhost:11434")
        print(f"   Tipo: Local")
        
    elif provider == "lmstudio":
        model = os.getenv("LMSTUDIO_MODEL", "local-model")
        print(f"🖥️  LM Studio")
        print(f"   Modelo: {model}")
        print(f"   URL: http://localhost:1234/v1")
        print(f"   Tipo: Local")
        
    elif provider == "openai":
        api_key = os.getenv("OPENAI_API_KEY", "NO_CONFIGURADO")
        model = os.getenv("OPENAI_MODEL", "gpt-4o-mini")
        print(f"🔑 OpenAI")
        print(f"   Modelo: {model}")
        print(f"   API Key: {'✅ Configurado' if api_key != 'NO_CONFIGURADO' else '❌ No configurado'}")
        print(f"   Tipo: Remoto")
        
    elif provider == "anthropic":
        api_key = os.getenv("ANTHROPIC_API_KEY", "NO_CONFIGURADO")
        model = os.getenv("ANTHROPIC_MODEL", "claude-3-5-sonnet-20241022")
        print(f"🔑 Anthropic")
        print(f"   Modelo: {model}")
        print(f"   API Key: {'✅ Configurado' if api_key != 'NO_CONFIGURADO' else '❌ No configurado'}")
        print(f"   Tipo: Remoto")
    
    print()
    print("=" * 60)
    print("💡 Para cambiar de proveedor:")
    print("   1. Edita .env")
    print("   2. Cambia MODEL_PROVIDER=<proveedor>")
    print("   3. Proveedores: ollama, lmstudio, openai, anthropic")
    print("=" * 60)

if __name__ == "__main__":
    test_provider_selection()
