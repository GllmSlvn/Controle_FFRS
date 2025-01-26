# 📱 Application SwiftUI - Gestion des Valeurs variables et Statistiques pour FFRS
Une application iOS développée avec SwiftUI et Core Data pour collecter des données statistiques et permettre une configuration simple.

## 🚀 Fonctionnalités principales
- Suivi des statistiques : Affiche des moyennes et des totaux (ex. : ERMP, lot circulaire, serrures).
- Personnalisation via configuration initiale :
Nombre de clients (clientCount) à configurer dans l'application.
- Stockage sécurisé dans UserDefaults.


## 🛠️ Technologies utilisées
- SwiftUI : Framework principal pour l'interface utilisateur.
- Core Data : Gestion locale des données.
- UserDefaults : Stockage des préférences utilisateur.
- MVVM Architecture : Séparation claire des responsabilités pour un code maintenable.

## 🖥️ Utilisation
1. Première configuration
    - L'application démarre avec un écran de configuration (SetupView).
    - Saisissez le nombre de clients souhaité et confirmez.
    - Vous serez redirigé vers l'écran principal (MainView).
2. Statistiques
    - Consultez les statistiques calculées à partir des données sauvegardées dans Core Data.
    - Les valeurs affichées incluent :
        - Moyenne ERMP.
        - Moyenne Lot Circulaire (basée sur le nombre de clients configurés).
        - Total des serrures.

## 📂 Structure du projet
1. Views :
2. SetupView : Écran de configuration initiale.
3. MainView : Vue principale pour afficher les statistiques et les options.
4. StatsView : Vue dédiée pour afficher les moyennes et les totaux.
5. Core Data : Modèle DailyData pour stocker les données statistiques.

## ✨ Capture d'écran (Exemple)
![Image](https://github.com/user-attachments/assets/0aa2331e-7ac3-4e57-b39e-f496182c5a0a)
![Image](https://github.com/user-attachments/assets/02b81ab3-dbdb-484e-a547-e2c7c642025c)
![Image](https://github.com/user-attachments/assets/3467a2f2-f00a-4792-8769-b579521bf4a2)
![Image](https://github.com/user-attachments/assets/2ac01d3c-0f92-4a9b-9d94-25e7f146fba2)

## 📄 License
Ce projet est sous licence MIT. Consultez le fichier LICENSE pour plus de détails.

## 💬 Contribution
Les contributions sont les bienvenues ! Si vous souhaitez signaler un bug ou proposer une nouvelle fonctionnalité :

## 📧 Contact
Créé par Guillaume Sylvain - N'hésitez pas à me contacter pour toute question ou suggestion.
