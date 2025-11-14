from langchain_ollama import ChatOllama
from langchain_openai import ChatOpenAI
from langchain_anthropic import ChatAnthropic
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.messages import HumanMessage, SystemMessage
import os
from dotenv import load_dotenv

load_dotenv()

def get_model(model_type: str = "ollama"):
    if model_type == "ollama":
        model_name = os.getenv("OLLAMA_MODEL", "gpt-oss:20b")
        print(f"🦙 Usando Ollama: {model_name}")
        model = ChatOllama(
            model=model_name,
            base_url="http://localhost:11434",
            temperature=0.7,
        )
    elif model_type == "openai":
        api_key = os.getenv("OPENAI_API_KEY")
        if not api_key:
            raise ValueError("OPENAI_API_KEY no encontrada en .env")
        model = ChatOpenAI(
            model="gpt-4o-mini",
            temperature=0.7,
            api_key=api_key,
        )
    elif model_type == "anthropic":
        api_key = os.getenv("ANTHROPIC_API_KEY")
        if not api_key:
            raise ValueError("ANTHROPIC_API_KEY no encontrada en .env")
        model = ChatAnthropic(
            model="claude-3-5-sonnet-20241022",
            temperature=0.7,
            api_key=api_key,
        )
    else:
        raise ValueError(f"Modelo no soportado: {model_type}")
    
    return model

if __name__ == "__main__":
    MODEL_TYPE = "ollama"
    
    model = get_model(MODEL_TYPE)
    
    messages = [
        SystemMessage(content="You are a helpful assistant. Answer in Spanish when the user writes in Spanish."),
        HumanMessage(content="¿Cuál es la capital de Francia y por qué es famosa? Responde en máximo 2 frases.")
    ]
    
    response = model.invoke(messages)
    print(f"\n{response.content}\n")

