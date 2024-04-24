----Nom des lieux qui finissent par 'um'.----

SELECT l.nom_lieu
FROM lieu l
WHERE l.nom_lieu LIKE '%um'

----Nombre de personnages par lieu (trié par nombre de personnages décroissant).----

SELECT COUNT(p.id_personnage), l.nom_lieu FROM personnage p 
INNER JOIN lieu l ON l.id_lieu = p.id_lieu
GROUP BY l.nom_lieu
ORDER BY l.nom_lieu DESC

----Nom des personnages + spécialité + adresse et lieu d'habitation, triés par lieu puis par nom de personnage.----

SELECT p.nom_personnage, s.nom_specialite, p.adresse_personnage, l.nom_lieu  FROM personnage p
INNER JOIN lieu l ON l.id_lieu = p.id_lieu
INNER JOIN specialite s ON s.id_specialite = p.id_specialite
ORDER BY l.nom_lieu DESC, p.nom_personnage DESC

----Nom des spécialités avec nombre de personnages par spécialité (trié par nombre de personnages décroissant).----

SELECT s.nom_specialite, COUNT(p.id_personnage) AS nb_personnage FROM personnage p
INNER JOIN specialite s ON s.id_specialite = p.id_specialite
GROUP BY s.nom_specialite
ORDER BY nb_personnage DESC

----Nom, date et lieu des batailles, classées de la plus récente à la plus ancienne (dates affichées au format jj/mm/aaaa).----

SELECT b.nom_bataille, DATE_FORMAT(b.date_bataille, '%d/%m/%Y') AS date_battaille, l.nom_lieu FROM bataille b
INNER JOIN lieu l ON l.id_lieu = b.id_lieu
ORDER BY DATE_FORMAT(date_bataille, '%Y/%m/%d') DESC

----Nom des potions + coût de réalisation de la potion (trié par coût décroissant).----

SELECT p.nom_potion, SUM(i.cout_ingredient * c.qte) AS price_total FROM potion p
INNER JOIN composer c ON c.id_potion = p.id_potion
INNER JOIN ingredient i ON i.id_ingredient = c.id_ingredient
GROUP BY p.nom_potion
ORDER BY price_total DESC

----Nom des ingrédients + coût + quantité de chaque ingrédient qui composent la potion 'Santé'.----


SELECT i.nom_ingredient, i.cout_ingredient * c.qte FROM ingredient i
INNER JOIN composer c ON c.id_ingredient = i.id_ingredient
INNER JOIN potion p ON p.id_potion = c.id_potion
WHERE p.nom_potion = "Santé"

----Nom du ou des personnages qui ont pris le plus de casques dans la bataille 'Bataille du village gaulois'.----

SELECT p.nom_personnage, SUM(pc.qte) AS nbCasques FROM personnage p
INNER JOIN prendre_casque pc ON pc.id_personnage = p.id_personnage
INNER JOIN bataille b ON b.id_bataille = pc.id_bataille
WHERE b.nom_bataille = 'Bataille du village gaulois'
GROUP BY p.nom_personnage
HAVING nbCasques >= ALL (
	SELECT SUM(pc.qte) FROM  prendre_casque pc
	INNER JOIN bataille b ON b.id_bataille = pc.id_bataille
	WHERE b.nom_bataille = 'Bataille du village gaulois'
	GROUP BY pc.id_personnage
)

--Solution View

SELECT nb.nbCasques FROM nbcasquepris nb
WHERE nbCasques >= ALL (
	SELECT SUM(pc.qte) FROM  prendre_casque pc
	INNER JOIN bataille b ON b.id_bataille = pc.id_bataille
	WHERE b.nom_bataille = 'Bataille du village gaulois'
	GROUP BY pc.id_personnage
)

----Nom des personnages et leur quantité de potion bue (en les classant du plus grand buveur au plus petit).----

SELECT p.nom_personnage, SUM(b.dose_boire) as sommeBue FROM personnage p
INNER JOIN boire b ON b.id_personnage = p.id_personnage
GROUP BY p.nom_personnage
ORDER BY sommeBue DESC

----Nom de la bataille où le nombre de casques pris a été le plus important.---- pas trouver

--Solution View
SELECT nb.nbCasque, nb.nom_bataille FROM nbcasquebataille nb
ORDER BY nb.nbCasque DESC
LIMIT 1

----Combien existe-t-il de casques de chaque type et quel est leur coût total ? (classés par nombre décroissant)----

SELECT tc.nom_type_casque, COUNT(c.id_casque ) AS nb_casques, SUM(c.cout_casque) AS cout_total FROM casque c 
INNER JOIN type_casque tc ON tc.id_type_casque = c.id_type_casque
GROUP BY tc.nom_type_casque
ORDER BY cout_total DESC 

----Nom des potions dont un des ingrédients est le poisson frais.----

SELECT p.nom_potion FROM potion p
INNER JOIN composer c ON p.id_potion = c.id_potion
INNER JOIN ingredient i ON c.id_ingredient = i.id_ingredient 
WHERE i.nom_ingredient = "Poisson frais"

----Nom du / des lieu(x) possédant le plus d'habitants, en dehors du village gaulois.----

--Solution View
SELECT nb.nb_personnage, nb.nom_lieu FROM nbhabitantvillage nb
WHERE nb.nb_personnage >= ALL (
	SELECT COUNT(p.id_personnage) FROM personnage p
	INNER JOIN lieu l ON l.id_lieu = p.id_lieu
	WHERE l.nom_lieu != "Village gaulois"
	GROUP BY l.nom_lieu
)

----Nom des personnages qui n'ont jamais bu aucune potion.----

SELECT p.nom_personnage, b.dose_boire FROM personnage p
INNER JOIN boire b ON b.id_personnage = p.id_personnage
ORDER BY b.dose_boire DESC

----Nom du / des personnages qui n'ont pas le droit de boire de la potion 'Magique'.----

SELECT p.nom_personnage FROM personnage p
INNER JOIN autoriser_boire ab ON ab.id_personnage = p.id_personnage
INNER JOIN potion po ON po.id_potion = ab.id_potion
WHERE po.nom_potion = "Magique"
