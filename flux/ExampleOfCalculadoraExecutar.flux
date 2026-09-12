use AgentOfCalculadora as CA

use AgentOfCalculadora::{somar as adicao}
use AgentOfCalculadora::{subtrair as subtracao}
use AgentOfCalculadora::{dividirInteiro as divisaoExata}
use AgentOfCalculadora::{restoDivisao as modulo}
use AgentOfCalculadora::{multiplicar as multiplicacao}

program (ExampleOfCalculadoraExecutar) {
      mut as int64: valor_x = 15
      mut as int64: valor_y = 4

      print("Adicao")
      adicao(valor_x, valor_y) --> print
      CA::somar(valor_x, valor_y) --> print

      print("Subtracao")
      subtracao(valor_x, valor_y) --> print
      CA::subtrair(valor_x, valor_y) --> print

      print("Divisao inteira")
      divisaoExata(valor_x, valor_y) --> print
      CA::dividirInteiro(valor_x, valor_y) --> print

      print("Resto da divisao")
      modulo(valor_x, valor_y) --> print
      CA::restoDivisao(valor_x, valor_y) --> print

      print("Multiplicacao")
      multiplicacao(valor_x, valor_y) --> print
      CA::multiplicar(valor_x, valor_y) --> print
}
