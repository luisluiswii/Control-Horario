from fastapi import APIRouter

router = APIRouter(
    prefix="/ejemplo",
    tags=["Ejemplo"]
)

@router.get("/")
def get_ejemplo():
    return {"mensaje": "Hola desde el router"}