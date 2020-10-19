//drop graph
MATCH (n)
DETACH DELETE n;

//drop index
DROP INDEX ON :Tweet(id);
DROP INDEX ON :User(user_id);
DROP INDEX ON :HashTag(name);