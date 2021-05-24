﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text;

namespace Facile.BusinessPortal.Model.Compra.Servico
{
    public class SubItemConta : Base
    {
        public string Codigo { get; set; }
        public string Descricao { get; set; }

        public long ClasseValorID { get; set; }
        [ForeignKey("ClasseValorID")]
        public virtual ClasseValor ClasseValor { get; set; }

        public long ItemContaID { get; set; }
        [ForeignKey("ItemContaID")]
        public virtual ItemConta ItemConta { get; set; }
    }
}