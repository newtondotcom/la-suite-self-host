# LaSuite Umbrella Chart

Ce chart Helm permet de déployer l'intégralité de LaSuite (Keycloak, Docs, Drive, Meet, People) sur Kubernetes.

## Architecture

C'est un **Umbrella Chart** (chart parent) qui intègre tous les composants LaSuite :

```
lasuite/
├── keycloak        (Authentification & Autorisation)
├── docs            (Impress)
├── drive
├── meet
└── people          (Desk)
```

Chaque composant peut être activé/désactivé individuellement.

## Prérequis

- Kubernetes 1.24+
- Helm 3.0+
- cert-manager (pour les certificats TLS)
- Suffisant de ressources (CPU/mémoire) pour tous les composants
- Helm repository Bitnami ajouté : `helm repo add bitnami https://charts.bitnami.com/bitnami`

## Installation

### 1. Ajouter le repository Bitnami

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

### 2. Mettre à jour les dépendances

```bash
cd helm/lasuite
helm dependency update
```

### 3. Déployer le chart

```bash
# Avec les valeurs par défaut
helm install lasuite . -n lasuite --create-namespace

# Avec des valeurs personnalisées
helm install lasuite . -n lasuite --create-namespace -f values-prod.yaml
```

### 4. Vérifier le déploiement

```bash
kubectl get pods -n lasuite
kubectl get svc -n lasuite
kubectl get ingress -n lasuite
```

## Configuration

### Activer/Désactiver des composants

```bash
helm install lasuite . -n lasuite \
  --set keycloak.enabled=true \
  --set docs.enabled=true \
  --set drive.enabled=true \
  --set meet.enabled=true \
  --set people.enabled=true
```

### Configurer Keycloak

```yaml
keycloak:
  enabled: true
  auth:
    adminUser: admin
    adminPassword: votre-motdepasse
  ingress:
    hostname: keycloak.yourdomain.com
  postgresql:
    auth:
      password: db-password
```

### Configurer les domaines

Modifier `values.yaml` pour configurer les domaines :

```yaml
docs:
  ingress:
    hostname: docs.yourdomain.com
drive:
  ingress:
    hostname: drive.yourdomain.com
meet:
  ingress:
    hostname: meet.yourdomain.com
people:
  ingress:
    hostname: people.yourdomain.com
```

## Mise à jour

```bash
# Mettre à jour les dépendances
helm dependency update helm/lasuite

# Mettre à niveau le déploiement
helm upgrade lasuite . -n lasuite -f values.yaml
```

## Désinstallation

```bash
helm uninstall lasuite -n lasuite
```

## Fichiers de configuration par environnement

- `values.yaml` - Configuration de base
- `values-dev.yaml` - Développement (ressources réduites)
- `values-prod.yaml` - Production (haute disponibilité)

## Accès par défaut

Après le déploiement :

- **Keycloak Admin**: https://keycloak.lasuite.example.com (user: admin)
- **Docs**: https://docs.lasuite.example.com
- **Drive**: https://drive.lasuite.example.com
- **Meet**: https://meet.lasuite.example.com
- **People**: https://people.lasuite.example.com

## Dépannage

### Vérifier les logs

```bash
# Logs Keycloak
kubectl logs -n lasuite deployment/keycloak

# Logs des composants LaSuite
kubectl logs -n lasuite deployment/docs
kubectl logs -n lasuite deployment/drive
kubectl logs -n lasuite deployment/meet
kubectl logs -n lasuite deployment/people
```

### Accès à Keycloak

```bash
kubectl port-forward -n lasuite svc/keycloak 8080:80
# Accéder à http://localhost:8080
```

### Accès aux bases de données

```bash
# Keycloak DB
kubectl port-forward -n lasuite svc/keycloak-postgresql 5432:5432

# Base de données partagée (si activée)
kubectl port-forward -n lasuite svc/postgresql 5433:5432
```

## Structure des chemins

Les sous-dépendances locales pointent vers les chemins relatifs des submodules :

- `../docs/src/helm/impress`
- `../drive/src/helm/drive`
- `../meet/src/helm/meet`
- `../people/src/helm/desk`

Assurez-vous que tous les submodules sont initialisés :

```bash
git submodule update --init --recursive
```
