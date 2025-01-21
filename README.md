# IOT-STRI-2025

# 1. Contexte et contraintes
- Détecteur sur la porte : Il détecte simplement qu'un badge BLE est passé, sans distinction d’entrée ou de sortie.
- Détecteur dans la salle : Il vérifie périodiquement les badges présents dans la salle.
- Solution : L’état (entrée ou sortie) doit être déduit en croisant les informations des deux détecteurs, notamment en comparant les détections de la porte avec les scans périodiques du détecteur de présence dans la salle.

# 2. Scénarios pour le tableau de bord des présents

## 2.1 Détection d’un badge à la porte

- Déclencheur :
Le détecteur de la porte détecte un badge BLE.

- Action système :
 1. Le système vérifie si le badge est déjà marqué comme "présent" dans la salle (grâce au détecteur de présence).
 2. Si le badge n'est pas détecté dans la salle :
  - Le système considère que la personne entre dans la salle.
  - Le badge est ajouté à la liste des présents avec l’heure d’entrée.
 3. Si le badge est déjà détecté dans la salle :
  - Le système considère que la personne sort de la salle.
  - Le badge est retiré de la liste des présents, et l’heure de sortie est enregistrée.

## 2.2 Mise à jour des présents via le détecteur dans la salle

Déclencheur :
Le détecteur dans la salle scanne périodiquement les badges présents.

Action système :
Le système met à jour la liste des présents pour confirmer que chaque badge scanné est encore dans la salle.
Si un badge marqué comme "présent" n’est pas détecté pendant plusieurs cycles (ex : 5 minutes), il est retiré de la liste des présents.

# 3. Scénarios pour le tableau de bord des warnings (anomalies)

## 3.1 Badge inconnu détecté à la porte

Déclencheur :
Le détecteur de la porte détecte un badge BLE non enregistré dans la base de données.

Action système :
Une alerte est générée indiquant "Badge inconnu détecté" avec l’adresse @Mac @idet l’heure correspondante.
Cette alerte est affichée dans le tableau des warnings.

## 3.2 Badge détecté à la porte mais absence de présence confirmée

Déclencheur :
Un badge est détecté à la porte, mais le détecteur de présence dans la salle ne le détecte pas par la suite.

Action système :
Une alerte "Badge non confirmé dans la salle" est générée.
Le tableau des warnings affiche cette alerte avec l’adresse @Mac et l’heure de détection à la porte.

## 3.3 Badge détecté dans la salle mais non détecté à la porte

Déclencheur :
Le détecteur dans la salle détecte un badge qui n’a pas été scanné à la porte.

Action système :
Une alerte "Présence non validée par la porte" est générée.
Le tableau des warnings affiche cette alerte avec l’adresse @Mac et l’heure de détection.

## 3.4 Absence de scans périodiques pour un badge marqué comme présent

Déclencheur :
Un badge marqué comme "présent" n’est pas détecté par le détecteur dans la salle pendant plusieurs cycles (ex : 5 minutes).

Action système :
Une alerte "Absence potentielle détectée" est générée.
Le tableau des warnings affiche cette alerte avec l’adresse @Mac et la dernière heure de détection.

## 3.5 Badge multiple pour une seule personne

Déclencheur :
Le détecteur (porte ou salle) détecte deux (ou plusieurs) adresses @Mac associées à un seul étudiant dans la base de données.

Action système :
Le système identifie que les deux @Mac détectées appartiennent à la même personne en consultant la base de données.
Une alerte est générée dans le tableau des warnings :
Message d'erreur : "Usage multiple de badges pour une même personne détecté".
Détails inclus : les deux @Mac impliquées, l’identifiant de l’étudiant, et l’heure de détection.
Le tableau des warnings met en évidence ce problème pour alerter l’administrateur.
