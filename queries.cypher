//Q1
MATCH (t:Tweet)
WHERE NOT exists((t)-[:RETWEET|REPLY_TO]-(:Tweet))
RETURN count(DISTINCT t) AS Q1_results;	

//Q2
MATCH p=(t:Tweet)-[r:HAS_TAG_OF]->(ht:HashTag)
WHERE NOT exists((t)-[:RETWEET]->(:Tweet))
RETURN ht.name AS Q2_tag, count(DISTINCT t) AS tag_count
ORDER BY tag_count DESC LIMIT 5;

//Q3
MATCH (ct:Tweet)-[:RETWEET|REPLY_TO*]->(pt:Tweet)
RETURN pt.id AS Q3_root_id, count(DISTINCT ct) AS descendant_count
ORDER BY descendant_count DESC LIMIT 1;

//Q4
MATCH (u:User)-[:CREATED]->(ct:Tweet)-[:RETWEET|REPLY_TO*]->(pt:Tweet)
RETURN pt.id AS Q4_root_id, count(DISTINCT u.user_id) AS user_count
ORDER BY user_count DESC LIMIT 1;

//Q5
MATCH p=(:Tweet)<-[:RETWEET|REPLY_TO*]-(:Tweet)
WITH length(p) AS Q5_length,nodes(p) AS ts
ORDER BY Q5_length DESC LIMIT 1
UNWIND ts AS tweet
RETURN Q5_length, collect(tweet.id) AS tweets;

//Q6
MATCH (mu:User)<-[mr:MENTION]-(ct:Tweet)
WHERE NOT exists{
			MATCH (ct)-[:RETWEET|REPLY_TO*]->(ru:User)
			WHERE mu.user_id=ru.user_id
		}
RETURN mu.user_id AS user_id,count(DISTINCT ct) AS mention_count 
ORDER BY mention_count DESC LIMIT 1;
