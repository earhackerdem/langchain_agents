#!/usr/bin/env python3
"""
Script para probar la conexión con Ollama y ver modelos disponibles
"""

import requests
import json

OLLAMA_URL = "http://localhost:11434"

def test_connection():
    """Probar conexión básica con Ollama"""
    try:
        response = requests.get(f"{OLLAMA_URL}/api/tags", timeout=5)
        if response.status_code == 200:
            data = response.json()
            models = data.get("models", [])
            
            print("✅ Conexión exitosa con Ollama")
            print(f"📦 Modelos disponibles: {len(models)}\n")
            
            for model in models:
                name = model.get("name", "Unknown")
                size = model.get("size", 0)
                size_gb = size / (1024**3)
                print(f"  🤖 {name}")
                print(f"     Tamaño: {size_gb:.2f} GB")
                print(f"     Familia: {model.get('details', {}).get('family', 'Unknown')}")
                print(f"     Parámetros: {model.get('details', {}).get('parameter_size', 'Unknown')}")
                print()
            
            return True
        else:
            print(f"❌ Error de conexión. Status: {response.status_code}")
            return False
    except requests.exceptions.RequestException as e:
        print(f"❌ No se pudo conectar a Ollama: {e}")
        print("\n💡 Asegúrate de que Ollama está corriendo:")
        print("   En Windows: Abre Ollama desde el menú de inicio")
        print("   En WSL: ollama serve")
        return False

def test_generate():
    """Probar generación de texto con el modelo"""
    try:
        print("🧪 Probando generación de texto...")
        response = requests.post(
            f"{OLLAMA_URL}/api/generate",
            json={
                "model": "gpt-oss:20b",
                "prompt": "¿Qué es Python en una frase?",
                "stream": False
            },
            timeout=30
        )
        
        if response.status_code == 200:
            result = response.json()
            print("✅ Generación exitosa!")
            print(f"📝 Respuesta: {result.get('response', '')}\n")
            return True
        else:
            print(f"❌ Error en generación: {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

if __name__ == "__main__":
    print("="*60)
    print("🔍 TEST DE OLLAMA")
    print("="*60 + "\n")
    
    if test_connection():
        print("\n" + "="*60)
        test_generate()
        print("="*60 + "\n")
        print("✅ Todo funciona correctamente!")
        print("🚀 Puedes ejecutar: python main.py")
    else:
        print("\n❌ Por favor revisa la conexión con Ollama")

