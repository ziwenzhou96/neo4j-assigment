//create index
CREATE INDEX ON :Tweet(id);
CREATE INDEX ON :User(user_id);
CREATE INDEX ON :HashTag(name);

//load data
CALL apoc.load.json("file:///tweets_cognitive_test.json")
YIELD value
MERGE (t:Tweet{id:value.id})
MERGE (u:User{user_id:value.user_id})
MERGE (u)-[:CREATED]->(t);

CALL apoc.load.json("file:///tweets_cognitive_test.json")
YIELD value where value.user_mentions is not null
UNWIND value.user_mentions AS user_mention
MERGE (u:User{user_id:user_mention.id})
WITH DISTINCT u,value
MATCH (t:Tweet{id:value.id}),(u)
WHERE NOT exists((:Tweet{id:value.id})-[:MENTION]->(u))
MERGE (t)-[:MENTION]->(u);

CALL apoc.load.json("file:///tweets_cognitive_test.json")
YIELD value where value.retweet_id is not null
MATCH (t:Tweet{id:value.id})
MERGE (ret:Tweet{id:value.retweet_id})
MERGE (t)-[:RETWEET]->(ret)
MERGE (retu:User{user_id:value.retweet_user_id})
MERGE (t)-[:RETWEET]->(retu);

CALL apoc.load.json("file:///tweets_cognitive_test.json")
YIELD value where value.replyto_id is not null
MATCH (t:Tweet{id:value.id})
MERGE (rep:Tweet{id:value.replyto_id})
MERGE (t)-[:REPLY_TO]->(rep)
MERGE (repu:User{user_id:value.replyto_user_id})
MERGE (t)-[:REPLY_TO]->(repu);

CALL apoc.load.json("file:///tweets_cognitive_test.json")
YIELD value where value.hash_tags is not null
UNWIND value.hash_tags AS hash_tag
MERGE (ht:HashTag{name:hash_tag.text})
WITH DISTINCT ht,value
MATCH (t:Tweet{id:value.id}),(ht)
WHERE NOT exists((t)-[:HAS_TAG_OF]->(ht))
MERGE (t)-[:HAS_TAG_OF]->(ht);
