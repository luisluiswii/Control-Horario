from fastapi import FastAPI
from routers import ejemplo_router

app = FastAPI()

app.include_router(ejemplo_router.router)

@app.get("/")
def root():
    return {"message": "API funcionando"}