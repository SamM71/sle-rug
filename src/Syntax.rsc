module Syntax

extend lang::std::Layout;
extend lang::std::Id;

/*
 * Concrete syntax of QL
 */

start syntax Form 
  = "form" Id name "{" Question* questions "}"; 

//In order: question, computed question, block, if-then, if-then-else
syntax Question 
  = Str Id":" Type
  | Str Id":" Type "=" Expr
  | "{" Question* "}"
  | "if" "(" Expr ")" "{" Question* "}"
  | "if" "(" Expr ")" "{" Question* "}" "else" "{" Question* "}"
  ;

// +, -, *, /, &&, ||, !, >, <, <=, >=, ==, !=, literals (bool, int, str)
// Think about disambiguation using priorities and associativity
// and use C/Java style precedence rules (look it up on the internet)
syntax Expr 
  = Id \ "true" \ "false" // true/false are reserved keywords.
  | Bool
  | Int
  | Str
  | bracket "(" Expr ")"
  > "!" Expr
  > left (Expr "*" Expr   
        | Expr "/" Expr)
  > left (Expr "+" Expr
        | Expr "-" Expr)
  > left (Expr "\>" Expr
        | Expr "\>=" Expr
        | Expr "\<" Expr
        | Expr "\<=" Expr)
  > left (Expr "==" Expr
        | Expr "!=" Expr)
  > left Expr "&&" Expr
  > left Expr "||" Expr
  ;
  
syntax Type
  = "string"
  | "integer"
  | "boolean"
  ;

lexical Str = "\"" ![\"]*  "\"";

lexical Int = [0-9]+;

lexical Bool
  =  "true"
  | "false"
  ;



