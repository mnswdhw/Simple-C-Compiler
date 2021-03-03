/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    IF = 258,
    ELSE = 259,
    identifier = 260,
    array_identifier = 261,
    INT = 262,
    CHAR = 263,
    FLOAT = 264,
    WHILE = 265,
    RETURN = 266,
    MAIN = 267,
    int_literal = 268,
    string_literal = 269,
    float_literal = 270,
    char_literal = 271,
    assign_op = 272,
    tilda_op = 273,
    not_op = 274,
    logicand = 275,
    logicor = 276,
    doubleplus_op = 277,
    doubleminus_op = 278,
    leq_op = 279,
    geq_op = 280,
    doubleequal_op = 281,
    notequal_op = 282,
    l_op = 283,
    g_op = 284,
    leftshift_op = 285,
    rightshift_op = 286,
    bxor_op = 287,
    band_op = 288,
    bor_op = 289,
    sub_op = 290,
    add_op = 291,
    mul_op = 292,
    div_op = 293,
    mod_op = 294,
    comma_op = 295,
    pointer_op = 296
  };
#endif
/* Tokens.  */
#define IF 258
#define ELSE 259
#define identifier 260
#define array_identifier 261
#define INT 262
#define CHAR 263
#define FLOAT 264
#define WHILE 265
#define RETURN 266
#define MAIN 267
#define int_literal 268
#define string_literal 269
#define float_literal 270
#define char_literal 271
#define assign_op 272
#define tilda_op 273
#define not_op 274
#define logicand 275
#define logicor 276
#define doubleplus_op 277
#define doubleminus_op 278
#define leq_op 279
#define geq_op 280
#define doubleequal_op 281
#define notequal_op 282
#define l_op 283
#define g_op 284
#define leftshift_op 285
#define rightshift_op 286
#define bxor_op 287
#define band_op 288
#define bor_op 289
#define sub_op 290
#define add_op 291
#define mul_op 292
#define div_op 293
#define mod_op 294
#define comma_op 295
#define pointer_op 296

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
