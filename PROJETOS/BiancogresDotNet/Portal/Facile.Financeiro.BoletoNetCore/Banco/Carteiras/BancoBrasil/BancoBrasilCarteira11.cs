﻿using System;
using static System.String;

namespace Facile.Financeiro.BoletoNetCore
{
    [CarteiraCodigo("11/019")]
    internal class BancoBrasilCarteira11 : ICarteira<BancoBrasil>
    {
        internal static Lazy<ICarteira<BancoBrasil>> Instance { get; } = new Lazy<ICarteira<BancoBrasil>>(() => new BancoBrasilCarteira11());

        private BancoBrasilCarteira11()
        {

        }

        public void FormataNossoNumero(Boleto boleto)
        {
            // Carteira 11 - Variação 019: Convênio de 7 dígitos
            // Para convênios com 7 dígitos, não existe dígito de verificação do nosso número
            // Ou deve estar em branco (o banco irá gerar)
            // Ou deve estar com 17 posições, iniciando com o código do convênio

            if (boleto.Banco.Cedente.Codigo.Length != 7)
                throw new Exception("Não foi possível formatar o nosso número => Codigo do Contrato/Cendente tem que ter 7 digitos.");

            if (IsNullOrWhiteSpace(boleto.NossoNumero) || boleto.NossoNumero == "0000000000")
            {
                // Banco irá gerar Nosso Número
                boleto.NossoNumero = new String('0', 17);
                boleto.NossoNumeroDV = "";
                boleto.NossoNumeroFormatado = boleto.NossoNumero;
            }
            else
            {
                // Nosso Número informado pela empresa
                boleto.NossoNumero = boleto.Banco.Cedente.Codigo.Trim() + boleto.NossoNumero.Trim();

                if (boleto.NossoNumero.Length != 17 || !boleto.NossoNumero.StartsWith(boleto.Banco.Cedente.Codigo))
                    throw new Exception($"Nosso Número ({boleto.NossoNumero}) deve conter 17 dígitos e iniciar com \"{boleto.Banco.Cedente.Codigo}\".");
                boleto.NossoNumeroDV = "";
                boleto.NossoNumeroFormatado = boleto.NossoNumero;
            }
        }

        public string FormataCodigoBarraCampoLivre(Boleto boleto)
        {
            return $"000000{boleto.NossoNumero}{boleto.Carteira}";
        }
    }
}