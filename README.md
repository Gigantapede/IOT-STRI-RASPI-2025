# Scénarios de fonctionnement du système de détection et gestion des présences

## 1. Contexte et contraintes
### Détecteur sur la porte
- Il détecte simplement qu'un badge BLE est passé, sans distinction d’entrée ou de sortie.

### Détecteur dans la salle
- Il vérifie périodiquement les badges présents dans la salle.

### Solution
- L’état (entrée ou sortie) doit être déduit en croisant les informations des deux détecteurs, notamment en comparant les détections de la porte avec les scans périodiques du détecteur de présence dans la salle.

---

## 2. Scénarios pour le tableau de bord des présents

### 2.1 Détection d’un badge à la porte
**Déclencheur :**  
Le détecteur de la porte détecte un badge BLE.

**Action système :**  
1. Le système vérifie si le badge est déjà marqué comme "présent" dans la salle (grâce au détecteur de présence).
2. Si le badge **n'est pas détecté dans la salle** :
   - Le système considère que la personne **entre dans la salle**.
   - Le badge est ajouté à la liste des présents avec l’heure d’entrée.
3. Si le badge **est déjà détecté dans la salle** :
   - Le système considère que la personne **sort de la salle**.
   - Le badge est retiré de la liste des présents, et l’heure de sortie est enregistrée.

### 2.2 Mise à jour des présents via le détecteur dans la salle
**Déclencheur :**  
Le détecteur dans la salle scanne périodiquement les badges présents.

**Action système :**  
1. Le système met à jour la liste des présents pour confirmer que chaque badge scanné est encore dans la salle.
2. Si un badge marqué comme "présent" **n’est pas détecté pendant plusieurs cycles** (5 minutes) :
   - Le badge est retiré de la liste des présents.

---

## 3. Scénarios pour le tableau de bord des warnings (anomalies)

### 3.1 Badge inconnu détecté à la porte
**Déclencheur :**  
Le détecteur de la porte détecte un badge BLE non enregistré dans la base de données.

**Action système :**  
1. Une alerte est générée indiquant :  
   - "Badge inconnu détecté"  
   - Adresse @Mac et heure correspondante.
2. Cette alerte est affichée dans le tableau des warnings.

---

### 3.2 Badge détecté à la porte mais absence de présence confirmée
**Déclencheur :**  
Un badge est détecté à la porte, mais le détecteur de présence dans la salle ne le détecte pas par la suite.

**Action système :**  
1. Une alerte "Badge non confirmé dans la salle" est générée.
2. Le tableau des warnings affiche cette alerte avec :  
   - Adresse @Mac.  
   - Heure de détection à la porte.

---

### 3.3 Badge détecté dans la salle mais non détecté à la porte
**Déclencheur :**  
Le détecteur dans la salle détecte un badge qui n’a pas été scanné à la porte.

**Action système :**  
1. Une alerte "Présence non validée par la porte" est générée.
2. Le tableau des warnings affiche cette alerte avec :  
   - Adresse @Mac.  
   - Heure de détection.

---

### 3.4 Absence de scans périodiques pour un badge marqué comme présent
**Déclencheur :**  
Un badge marqué comme "présent" n’est pas détecté par le détecteur dans la salle pendant plusieurs cycles (5 minutes).

**Action système :**  
1. Une alerte "Absence potentielle détectée" est générée.
2. Le tableau des warnings affiche cette alerte avec :  
   - Adresse @Mac.  
   - Dernière heure de détection.

---

### 3.5 Badge multiple pour une seule personne
**Déclencheur :**  
Le détecteur (porte ou salle) détecte deux (ou plusieurs) adresses @Mac associées à un seul étudiant dans la base de données.

**Action système :**  
1. Le système identifie que les deux @Mac détectées appartiennent à la même personne en consultant la base de données.
2. Une alerte est générée dans le tableau des warnings :  
   - Message d'erreur : "Usage multiple de badges pour une même personne détecté".
   - Détails inclus :  
     - Les deux @Mac impliquées.  
     - L’identifiant de l’étudiant.  
     - Heure de détection.
3. Le tableau des warnings met en évidence ce problème pour alerter l’administrateur.
