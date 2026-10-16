#!/usr/bin/env bash
# Crée labels, milestones et issues du projet GreenRAN Monitor.
# Prérequis : GitHub CLI (gh) installé et connecté (gh auth login).
# Usage : depuis la racine du repo -> bash create-issues.sh
set -euo pipefail

echo "==> Labels"
gh label create backend  --color 1D76DB --force
gh label create frontend --color 0E8A16 --force
gh label create data     --color FBCA04 --force
gh label create ml       --color 5319E7 --force
gh label create devops   --color D93F0B --force
gh label create docs     --color 0075CA --force
gh label create feature  --color A2EEEF --force
gh label create chore    --color CFD3D7 --force

echo "==> Milestones"
for m in "M1 - Fondations" "M2 - Dashboard temps réel" "M3 - Analytics & prédiction" "M4 - Recommandation & livraison"; do
  gh api repos/:owner/:repo/milestones -f title="$m" >/dev/null || true
done

issue() { # titre | milestone | labels | corps
  gh issue create --title "$1" --milestone "$2" --label "$3" --body "$4"
}

echo "==> Issues M1 - Fondations"
issue "Renommer le projet (budget -> greenran)" "M1 - Fondations" "chore" \
"- [ ] Renommer package.json, angular.json, index.html
- [ ] Mettre à jour README et docker-compose
- [ ] Supprimer les écrans/code métier « budget »"

issue "Docker Compose : TimescaleDB + Kafka (KRaft)" "M1 - Fondations" "devops" \
"- [ ] Image timescale/timescaledb:latest-pg17
- [ ] Kafka en mode KRaft
- [ ] Healthchecks
- [ ] Fichier .env.example"

issue "Initialiser le backend Spring Boot (Java 21, Maven)" "M1 - Fondations" "backend" \
"Dépendances : Web, WebSocket, Kafka, JPA, PostgreSQL, Flyway, Validation, Actuator, Security.
Packages modulaires : ingestion, analytics, recommendation, alerting."

issue "Schéma BDD avec Flyway (site, site_metric hypertable)" "M1 - Fondations" "backend,data" \
"- [ ] Migration V1 : tables site et site_metric
- [ ] create_hypertable sur site_metric
- [ ] Index (site_id, time)
- [ ] Aggregats continus (1h, 1j)"

issue "Simulateur de KPI réseau (cycle jour/nuit)" "M1 - Fondations" "backend,data" \
"Génère pour N sites : traffic_mbps, prb_load_pct, energy_kwh, temperature_c.
- [ ] Profils jour/nuit/week-end
- [ ] Injection d'anomalies configurables
- [ ] Publication sur le topic Kafka kpi.raw"

issue "Ingestion : consumer Kafka vers TimescaleDB" "M1 - Fondations" "backend" \
"- [ ] Consumer kpi.raw
- [ ] Insertion en batch
- [ ] Gestion des erreurs / dead-letter topic
- [ ] Tests d'intégration (Testcontainers)"

issue "CI GitHub Actions (build + tests backend et frontend)" "M1 - Fondations" "devops" \
"- [ ] Workflow backend (Maven, Java 21)
- [ ] Workflow frontend (npm ci, lint, test, build)
- [ ] Cache des dépendances"

echo "==> Issues M2 - Dashboard temps réel"
issue "API REST : sites et métriques" "M2 - Dashboard temps réel" "backend" \
"- [ ] GET /api/sites
- [ ] GET /api/sites/{id}/metrics?from&to&bucket
- [ ] Pagination, validation, OpenAPI (springdoc)"

issue "Flux temps réel WebSocket/SSE" "M2 - Dashboard temps réel" "backend" \
"Diffuser les derniers KPI par site vers le frontend."

issue "Authentification (JWT ou Keycloak)" "M2 - Dashboard temps réel" "backend,frontend" \
"- [ ] Spring Security + JWT
- [ ] Rôles : viewer / ingénieur réseau / admin
- [ ] Guard et intercepteur Angular"

issue "Frontend : layout, routing et thème Angular Material" "M2 - Dashboard temps réel" "frontend" \
"- [ ] Standalone components + signals
- [ ] Navigation latérale
- [ ] Thème clair/sombre"

issue "Frontend : carte interactive des sites (Leaflet)" "M2 - Dashboard temps réel" "frontend,feature" \
"- [ ] Marqueurs colorés selon état (OK / alerte / veille)
- [ ] Popup avec KPI du site
- [ ] Filtres 4G/5G"

issue "Frontend : graphiques temps réel (ECharts)" "M2 - Dashboard temps réel" "frontend,feature" \
"- [ ] Trafic, charge PRB, énergie, température
- [ ] Sélecteur de période
- [ ] Mise à jour live via WebSocket"

echo "==> Issues M3 - Analytics & prédiction"
issue "Détection d'anomalies sur la consommation et les KPI" "M3 - Analytics & prédiction" "backend,ml" \
"- [ ] Méthode statistique de base (z-score / IQR glissant)
- [ ] Variante ML (Isolation Forest ou service Python)
- [ ] Stockage des anomalies détectées"

issue "Prédiction de trafic par site (J+1, par heure)" "M3 - Analytics & prédiction" "ml,backend" \
"- [ ] Jeu d'entraînement issu du simulateur / dataset public
- [ ] Modèle (Prophet ou LSTM)
- [ ] Endpoint /api/sites/{id}/forecast
- [ ] Métriques d'évaluation (MAPE)"

issue "Service d'alertes (règles + notifications)" "M3 - Analytics & prédiction" "backend,feature" \
"- [ ] Règles de seuil et anomalies
- [ ] Cycle de vie : ouverte / acquittée / résolue
- [ ] Notification email ou webhook"

issue "Frontend : vue Alertes et détail d'un site" "M3 - Analytics & prédiction" "frontend,feature" \
"- [ ] Liste filtrable des alertes
- [ ] Page détail : historique, prévision, anomalies"

echo "==> Issues M4 - Recommandation & livraison"
issue "Moteur de recommandation : mise en veille des cellules" "M4 - Recommandation & livraison" "backend,feature" \
"- [ ] Identifier les sites sous seuil de charge prévu
- [ ] Vérifier la couverture voisine (contrainte QoS)
- [ ] Planning de mise en veille proposé"

issue "Simulation what-if (économie vs risque QoS)" "M4 - Recommandation & livraison" "backend,frontend,feature" \
"- [ ] Estimation kWh, € et CO2 économisés
- [ ] Indicateur de risque sur la QoS
- [ ] Formulaire de simulation côté Angular"

issue "Rapport RSE exportable (PDF/CSV)" "M4 - Recommandation & livraison" "backend,frontend,feature" \
"Synthèse mensuelle : consommation, économies réalisées, émissions évitées."

issue "Observabilité : Prometheus + Grafana" "M4 - Recommandation & livraison" "devops" \
"- [ ] Actuator + Micrometer
- [ ] Dashboards Grafana (lag Kafka, latence API)"

issue "Dockeriser backend et frontend, déploiement" "M4 - Recommandation & livraison" "devops" \
"- [ ] Dockerfile multi-stage backend et frontend (nginx)
- [ ] docker-compose complet
- [ ] Déploiement (VPS, Azure ou autre)"

issue "Documentation : README, architecture, captures d'écran" "M4 - Recommandation & livraison" "docs" \
"- [ ] Schéma d'architecture
- [ ] Guide de démarrage rapide
- [ ] GIF/captures du dashboard"

echo "Terminé."
