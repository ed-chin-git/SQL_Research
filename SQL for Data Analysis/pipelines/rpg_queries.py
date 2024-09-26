"""-------------------------------------------------------------
             RPG DataBase Queries
----------------------------------------------------------------
"""
import sqlite3
import os


# ___ instantiate and return connection obj _________
def conx_sqlite(db):
    cnx = sqlite3.connect(db)
    return cnx


# ___ QUERIES _________________________________
def run_queries(c):
    print('----- R P G  D a t a b a s e   I N F O ------')
    # _____ How Many Total Characters_____________________
    qry = '''
    SELECT COUNT(character_id) FROM charactercreator_character
    '''
    for row in c.execute(qry):
        print('There are a total of', row[0], 'Characters')

    # _____ How many of each Character sublass  _____________
    qry = '''
    SELECT COUNT(character_ptr_id) FROM charactercreator_cleric
    '''
    for row in c.execute(qry):
        print(row[0], 'Clerics')

    qry = '''
    SELECT COUNT(character_ptr_id) FROM charactercreator_fighter
    '''
    for row in c.execute(qry):
        print(row[0], 'Fighters')

    qry = '''
    SELECT COUNT(character_ptr_id) FROM charactercreator_thief
    '''
    for row in c.execute(qry):
        print(row[0], 'Thieves')

    qry = '''
    SELECT COUNT(character_ptr_id) FROM charactercreator_mage
    '''
    for mage in c.execute(qry):
        qry2 = 'SELECT COUNT(mage_ptr_id) FROM charactercreator_necromancer'    
        for necro in c.execute(qry2):
            print(mage[0], 'Mages, of which', necro[0], 'are Necromancers')

    print()

    # _______________ How many Total Items _________________________________
    for i in c.execute('SELECT COUNT(item_id) FROM armory_item'):
        print('There are a total of', i[0], 'items')
    
    # _______________ How many of Weapons and Non-Weapons ________________
    for w in c.execute('SELECT COUNT(item_ptr_id) FROM armory_weapon'):
        print(w[0], 'Weapons')
    print((i[0] - w[0]), 'Non-Weapons')
    print()

    # _______________ how many Items does each Character have? ____________
    #  
    query1 = '''
    SELECT *
    FROM (
         SELECT  cc.name,
            count(item.item_id) as item_count,
            count(weapon.item_ptr_id) as weapon_count
            FROM charactercreator_character AS cc
            LEFT JOIN charactercreator_character_inventory AS inventory
            ON cc.character_id = inventory.character_id
            LEFT JOIN armory_item AS item
            ON inventory.item_id = item.item_id
            LEFT JOIN armory_weapon weapon
            ON weapon.item_ptr_id = item.item_id
            GROUP BY cc.name
            ORDER BY item_count DESC
            LIMIT 15
         )
    ;
    '''
    print('Character  -->  Items  / Weapons')
    print('-----------------------------')
    rows = c.execute(query1)
    for row in rows:
        name = row[0]
        print(name, '-->', row[1], '/', row[2])
    print('-----------------------------')

    # _____ On average, how many Items does each Character have? _________
    #   nested query
    query2 = '''
    SELECT AVG(item_count)
    FROM (
        SELECT c.name, count(i.item_id) as item_count
        FROM charactercreator_character AS c,
             charactercreator_character_inventory AS i,
             armory_item AS t
        WHERE c.character_id = i.character_id
          AND i.item_id = t.item_id
        GROUP BY c.name
        ORDER BY c.name
        );
    '''
    for i in c.execute(query2):
        print('Each character has average of', i[0], 'items\n')

    # _____ how many WEAPONS does each Character have? ___________________
    query1 = '''
    SELECT cc.name, item.name, weapon.power
        FROM charactercreator_character AS cc
        JOIN charactercreator_character_inventory AS inventory
          ON cc.character_id = inventory.character_id
        JOIN armory_item AS item
          ON inventory.item_id = weapon.item_ptr_id
        JOIN armory_weapon weapon
          ON weapon.item_ptr_id = item.item_id
        ORDER BY cc.name
        LIMIT 15;
    '''
    print('Character  --> Weapon:Power')
    print('------------------------------')
    rows = c.execute(query1)
    for row in rows:
        print(row[0], '-->', row[1], ':', row[2])
    print('------------------------------')

    query1 = '''
    SELECT cc.name, COUNT(item.name)
        FROM charactercreator_character AS cc
        LEFT JOIN charactercreator_character_inventory AS inventory
          ON cc.character_id = inventory.character_id
        LEFT JOIN armory_item AS item
          ON inventory.item_id = weapon.item_ptr_id
        INNER JOIN armory_weapon weapon
          ON weapon.item_ptr_id = item.item_id
        GROUP BY cc.name
        ORDER BY cc.name
        LIMIT 15;
    '''
    print()
    print('Character  -->  Weapon Count')
    print('------------------------------')
    rows = c.execute(query1)
    for row in rows:
        print(row[0], '-->', row[1])
    print('------------------------------')

    # ____ On average, how many Weapons does each Character have? ___________
    query2 = '''
    SELECT AVG(weapon_count)
    FROM (
        SELECT character.name, count(weapon.item_ptr_id) as weapon_count
            FROM charactercreator_character AS character,
                 charactercreator_character_inventory AS inventory,
                 armory_weapon AS weapon
            WHERE character.character_id = inventory.character_id
            AND inventory.item_id = weapon.item_ptr_id
            GROUP BY character.name
            ORDER BY character.name
            );
    '''
    for i in c.execute(query2):
        print('Each character has average of', i[0], 'weapons\n')

    # ___ Use cursor object fetch method ___
    print('There are a total of', c.execute("SELECT COUNT(item_id) FROM armory_item").fetchone()[0], 'items')

    # --bye --
    return


def main():
    #  DB filepath = current directory
    DB_FILEPATH = os.path.join(os.path.dirname(__file__), "rpg_db.sqlite3")
    conn = conx_sqlite(DB_FILEPATH)  # create connection 
    conn.row_factory = sqlite3.Row  # Use row objects per Mike Rossetti
    cur = conn.cursor()  # create cursor
    run_queries(cur)
    cur.close()   # close cursor
    conn.close()  # close connection
    return

#  Launched from the command line
if __name__ == '__main__':
    print('\n'*100)  # force teminal to clear screen
    main()
