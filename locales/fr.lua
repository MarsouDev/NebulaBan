Locales = Locales or {}
Locales['fr'] = {
    -- Messages système de ban
    ["ban_success"] = "^2Le joueur ^7%s ^2a été banni avec l'ID: ^7%s",
    ["ban_failed"] = "^1Échec du bannissement du joueur: ^7%s",
    ["ban_already_banned"] = "^3Le joueur est déjà banni avec l'ID: ^7%s",
    ["ban_player_not_found"] = "^1Joueur introuvable",
    ["ban_invalid_duration"] = "^1Durée de ban invalide. Utilisez des chiffres (heures) ou 0 pour permanent",
    
    -- Messages système de déban
    ["unban_success"] = "^2L'ID de ban ^7%s ^2a été supprimé avec succès",
    ["unban_failed"] = "^1Échec du déban de l'ID: ^7%s",
    ["unban_not_found"] = "^1L'ID de ban ^7%s ^1est introuvable ou déjà inactif",
    
    -- Messages de vérification de ban
    ["check_banned"] = "^1Le joueur est banni:\n^7Raison: %s\n^7Banni par: %s\n^7ID Ban: %s\n^7Date: %s",
    ["check_not_banned"] = "^2Le joueur n'est pas banni",
    ["check_permanent"] = "Permanent",
    ["check_expires"] = "Expire le: %s",
    
    -- Utilisation des commandes
    ["usage_ban"] = "^3Usage: ^7/%s [id_joueur] [durée_heures] [raison]",
    ["usage_unban"] = "^3Usage: ^7/%s [id_ban]",
    ["usage_checkban"] = "^3Usage: ^7/%s [id_joueur]",
    
    -- Messages généraux
    ["no_permission"] = "^1Vous n'avez pas la permission d'utiliser cette commande",
    ["invalid_player"] = "^1ID de joueur invalide",
    ["command_error"] = "^1Une erreur s'est produite lors de l'exécution de la commande"
}