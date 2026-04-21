from pydantic import BaseModel

class UsuarioSchema(BaseModel):
    nombre: str