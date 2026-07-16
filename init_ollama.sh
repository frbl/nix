#!/bin/sh
ollama serve
ollama pull qwen2.5-coder:7b
ollama pull deepseek-coder-v2:lite
ollama pull llama3.1:8b
ollama run qwen2.5-coder:7b
