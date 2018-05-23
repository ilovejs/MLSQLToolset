# java -jar codebuff-1.5.1.jar  \
#     -rule grammarSpec \
#     -g org.antlr.codebuff.SQLite \
#     -corpus corpus/sql/training \
#     -files sql \
#     -indent 4 \
#     -comment LINE_COMMENT \
#     Ranks.sql


# Grammer file locate in: grammars/org/antlr/codebuff    

# -rule compilationUnit \
# org.antlr.codebuff.tsqlParser.compilationUnit()
    # -g org.antlr.codebuff.tsql \

# try sqlite
java -jar target/codebuff-1.5.1.jar \
    -g org.antlr.codebuff.SQLite \
    -rule tsql_file \
    -corpus corpus/sql/training \
    -files sql -indent 4 -comment LINE_COMMENT \
    rsc/sql1.sql

#try tsql
java -jar target/codebuff-1.5.1.jar \
    -g org.antlr.codebuff.tsql \
    -rule tsql_file \
    -corpus corpus/sql/training \
    -files sql -indent 4 -comment LINE_COMMENT \
    rsc/sql1.sql

## g4 working examples:
java -jar target/codebuff-1.5.1.jar \
    -g org.antlr.codebuff.ANTLRv4 \
    -rule grammarSpec \
    -corpus corpus/antlr4/training \
    -files g4 -indent 4 -comment LINE_COMMENT \
    rsc/tsql.g4

## java working example:
java -jar target/codebuff-1.5.1.jar \
    -g org.antlr.codebuff.Java \
    -rule compilationUnit \
    -corpus corpus/java/training/stringtemplate4  \
    -files java -comment LINE_COMMENT \
    rsc/AnalysisPipeline.java
