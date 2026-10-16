<<<<<<< HEAD
# Budget Kanban

Application de suivi de budget où les prélèvements et achats sont des cartes
déplacées entre colonnes (À venir / Prélevé / À vérifier).

## Prérequis
Java 21+, Node.js LTS, Docker

## Lancer le projet
```bash
docker compose up -d          # base PostgreSQL
cd backend && ./mvnw spring-boot:run
cd frontend && npm install && ng serve
```

Back : http://localhost:8080/actuator/health  
Front : http://localhost:4200
=======
# GreenRAN
Monitor yor 5G antennas to save energy
>>>>>>> dc8a86b (chore: reconversion du projet en GreenRAN Monitor (backend, docker, backlog))
