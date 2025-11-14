from langchain_ollama import ChatOllama
from langchain_openai import ChatOpenAI
from langchain_anthropic import ChatAnthropic
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.messages import HumanMessage, SystemMessage
import os
from dotenv import load_dotenv

load_dotenv()

def get_model(provider: str = "ollama"):
    if provider == "ollama":
        model_name = os.getenv("OLLAMA_MODEL", "gpt-oss:20b")
        print(f"🦙 Usando Ollama: {model_name}")
        model = ChatOllama(
            model=model_name,
            base_url="http://localhost:11434",
            temperature=0.7,
        )
    elif provider == "lmstudio":
        model_name = os.getenv("LMSTUDIO_MODEL", "local-model")
        print(f"🖥️  Usando LM Studio: {model_name}")
        model = ChatOpenAI(
            base_url="http://localhost:1234/v1",
            api_key="lm-studio",
            model=model_name,
            temperature=0.7,
        )
    elif provider == "openai":
        api_key = os.getenv("OPENAI_API_KEY")
        if not api_key:
            raise ValueError("OPENAI_API_KEY no encontrada en .env")
        model_name = os.getenv("OPENAI_MODEL", "gpt-4o-mini")
        print(f"🔑 Usando OpenAI: {model_name}")
        model = ChatOpenAI(
            model=model_name,
            temperature=0.7,
            api_key=api_key,
        )
    elif provider == "anthropic":
        api_key = os.getenv("ANTHROPIC_API_KEY")
        if not api_key:
            raise ValueError("ANTHROPIC_API_KEY no encontrada en .env")
        model_name = os.getenv("ANTHROPIC_MODEL", "claude-3-5-sonnet-20241022")
        print(f"🔑 Usando Anthropic: {model_name}")
        model = ChatAnthropic(
            model=model_name,
            temperature=0.7,
            api_key=api_key,
        )
    else:
        raise ValueError(f"Proveedor no soportado: {provider}")
    
    return model

if __name__ == "__main__":
    MODEL_PROVIDER = os.getenv("MODEL_PROVIDER", "ollama")
    
    model = get_model(MODEL_PROVIDER)
    
    messages = [
        SystemMessage(content="You are a helpful assistant. Answer in Spanish when the user writes in Spanish."),
        HumanMessage(content="¿Cuál es la capital de Francia y por qué es famosa? Responde en máximo 2 frases.")
    ]
    
    response = model.invoke(messages)
    print(f"\n{response.content}\n")

