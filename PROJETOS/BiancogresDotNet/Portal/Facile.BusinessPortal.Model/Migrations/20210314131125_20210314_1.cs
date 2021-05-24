﻿using System;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;

namespace Facile.BusinessPortal.Model.Migrations
{
    public partial class _20210314_1 : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "SolicitacaoServicoItemMedicao");

            migrationBuilder.CreateTable(
                name: "SolicitacaoServicoMedicaoItem",
                columns: table => new
                {
                    ID = table.Column<long>(nullable: false)
                        .Annotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn),
                    InsertUser = table.Column<string>(nullable: true),
                    InsertDate = table.Column<DateTime>(nullable: true),
                    LastEditUser = table.Column<string>(nullable: true),
                    LastEditDate = table.Column<DateTime>(nullable: true),
                    StatusIntegracao = table.Column<int>(nullable: false),
                    DataHoraIntegracao = table.Column<DateTime>(nullable: true),
                    MensagemRetorno = table.Column<string>(nullable: true),
                    EmpresaID = table.Column<long>(nullable: false),
                    UnidadeID = table.Column<long>(nullable: true),
                    Habilitado = table.Column<bool>(nullable: false),
                    Deletado = table.Column<bool>(nullable: false),
                    DeleteID = table.Column<long>(nullable: false),
                    IDProcesso = table.Column<Guid>(nullable: true),
                    StageID = table.Column<long>(nullable: true),
                    SolicitacaoServicoMedicaoID = table.Column<long>(nullable: true),
                    SolicitacaoServicoItemID = table.Column<long>(nullable: false),
                    Data = table.Column<DateTime>(nullable: false),
                    UnidadeMedicao = table.Column<string>(nullable: true),
                    Quantidade = table.Column<decimal>(nullable: false),
                    SaldoMedicao = table.Column<decimal>(nullable: false),
                    ValorServico = table.Column<decimal>(nullable: false),
                    Medicao = table.Column<decimal>(nullable: false),
                    Valor = table.Column<decimal>(nullable: false),
                    Status = table.Column<int>(nullable: false),
                    DataMedicao = table.Column<DateTime>(nullable: true),
                    UsuarioID = table.Column<long>(nullable: true),
                    ObservacaoMedicao = table.Column<string>(nullable: true),
                    Observacao = table.Column<string>(nullable: true),
                    NomeAnexo = table.Column<string>(nullable: true),
                    TipoAnexo = table.Column<string>(nullable: true),
                    ArquivoAnexo = table.Column<byte[]>(nullable: true),
                    ObservacaoNotaFiscal = table.Column<string>(nullable: true),
                    NomeAnexoNotaFiscal = table.Column<string>(nullable: true),
                    TipoAnexoNotaFiscal = table.Column<string>(nullable: true),
                    ArquivoAnexoNotaFiscal = table.Column<byte[]>(nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_SolicitacaoServicoMedicaoItem", x => x.ID);
                    table.ForeignKey(
                        name: "FK_SolicitacaoServicoMedicaoItem_Empresa_EmpresaID",
                        column: x => x.EmpresaID,
                        principalTable: "Empresa",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_SolicitacaoServicoMedicaoItem_SolicitacaoServicoItem_SolicitacaoServicoItemID",
                        column: x => x.SolicitacaoServicoItemID,
                        principalTable: "SolicitacaoServicoItem",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_SolicitacaoServicoMedicaoItem_SolicitacaoServicoMedicao_SolicitacaoServicoMedicaoID",
                        column: x => x.SolicitacaoServicoMedicaoID,
                        principalTable: "SolicitacaoServicoMedicao",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_SolicitacaoServicoMedicaoItem_Unidade_UnidadeID",
                        column: x => x.UnidadeID,
                        principalTable: "Unidade",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_SolicitacaoServicoMedicaoItem_Usuario_UsuarioID",
                        column: x => x.UsuarioID,
                        principalTable: "Usuario",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_SolicitacaoServicoMedicaoItem_EmpresaID",
                table: "SolicitacaoServicoMedicaoItem",
                column: "EmpresaID");

            migrationBuilder.CreateIndex(
                name: "IX_SolicitacaoServicoMedicaoItem_SolicitacaoServicoItemID",
                table: "SolicitacaoServicoMedicaoItem",
                column: "SolicitacaoServicoItemID");

            migrationBuilder.CreateIndex(
                name: "IX_SolicitacaoServicoMedicaoItem_SolicitacaoServicoMedicaoID",
                table: "SolicitacaoServicoMedicaoItem",
                column: "SolicitacaoServicoMedicaoID");

            migrationBuilder.CreateIndex(
                name: "IX_SolicitacaoServicoMedicaoItem_UnidadeID",
                table: "SolicitacaoServicoMedicaoItem",
                column: "UnidadeID");

            migrationBuilder.CreateIndex(
                name: "IX_SolicitacaoServicoMedicaoItem_UsuarioID",
                table: "SolicitacaoServicoMedicaoItem",
                column: "UsuarioID");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "SolicitacaoServicoMedicaoItem");

            migrationBuilder.CreateTable(
                name: "SolicitacaoServicoItemMedicao",
                columns: table => new
                {
                    ID = table.Column<long>(nullable: false)
                        .Annotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn),
                    ArquivoAnexo = table.Column<byte[]>(nullable: true),
                    ArquivoAnexoNotaFiscal = table.Column<byte[]>(nullable: true),
                    Data = table.Column<DateTime>(nullable: false),
                    DataHoraIntegracao = table.Column<DateTime>(nullable: true),
                    DataMedicao = table.Column<DateTime>(nullable: true),
                    Deletado = table.Column<bool>(nullable: false),
                    DeleteID = table.Column<long>(nullable: false),
                    EmpresaID = table.Column<long>(nullable: false),
                    Habilitado = table.Column<bool>(nullable: false),
                    IDProcesso = table.Column<Guid>(nullable: true),
                    InsertDate = table.Column<DateTime>(nullable: true),
                    InsertUser = table.Column<string>(nullable: true),
                    LastEditDate = table.Column<DateTime>(nullable: true),
                    LastEditUser = table.Column<string>(nullable: true),
                    Medicao = table.Column<decimal>(nullable: false),
                    MensagemRetorno = table.Column<string>(nullable: true),
                    NomeAnexo = table.Column<string>(nullable: true),
                    NomeAnexoNotaFiscal = table.Column<string>(nullable: true),
                    Observacao = table.Column<string>(nullable: true),
                    ObservacaoMedicao = table.Column<string>(nullable: true),
                    ObservacaoNotaFiscal = table.Column<string>(nullable: true),
                    Quantidade = table.Column<decimal>(nullable: false),
                    SaldoMedicao = table.Column<decimal>(nullable: false),
                    SolicitacaoServicoItemID = table.Column<long>(nullable: false),
                    SolicitacaoServicoMedicaoID = table.Column<long>(nullable: true),
                    StageID = table.Column<long>(nullable: true),
                    Status = table.Column<int>(nullable: false),
                    StatusIntegracao = table.Column<int>(nullable: false),
                    TipoAnexo = table.Column<string>(nullable: true),
                    TipoAnexoNotaFiscal = table.Column<string>(nullable: true),
                    UnidadeID = table.Column<long>(nullable: true),
                    UnidadeMedicao = table.Column<string>(nullable: true),
                    UsuarioID = table.Column<long>(nullable: true),
                    Valor = table.Column<decimal>(nullable: false),
                    ValorServico = table.Column<decimal>(nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_SolicitacaoServicoItemMedicao", x => x.ID);
                    table.ForeignKey(
                        name: "FK_SolicitacaoServicoItemMedicao_Empresa_EmpresaID",
                        column: x => x.EmpresaID,
                        principalTable: "Empresa",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_SolicitacaoServicoItemMedicao_SolicitacaoServicoItem_SolicitacaoServicoItemID",
                        column: x => x.SolicitacaoServicoItemID,
                        principalTable: "SolicitacaoServicoItem",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_SolicitacaoServicoItemMedicao_SolicitacaoServicoMedicao_SolicitacaoServicoMedicaoID",
                        column: x => x.SolicitacaoServicoMedicaoID,
                        principalTable: "SolicitacaoServicoMedicao",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_SolicitacaoServicoItemMedicao_Unidade_UnidadeID",
                        column: x => x.UnidadeID,
                        principalTable: "Unidade",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_SolicitacaoServicoItemMedicao_Usuario_UsuarioID",
                        column: x => x.UsuarioID,
                        principalTable: "Usuario",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_SolicitacaoServicoItemMedicao_EmpresaID",
                table: "SolicitacaoServicoItemMedicao",
                column: "EmpresaID");

            migrationBuilder.CreateIndex(
                name: "IX_SolicitacaoServicoItemMedicao_SolicitacaoServicoItemID",
                table: "SolicitacaoServicoItemMedicao",
                column: "SolicitacaoServicoItemID");

            migrationBuilder.CreateIndex(
                name: "IX_SolicitacaoServicoItemMedicao_SolicitacaoServicoMedicaoID",
                table: "SolicitacaoServicoItemMedicao",
                column: "SolicitacaoServicoMedicaoID");

            migrationBuilder.CreateIndex(
                name: "IX_SolicitacaoServicoItemMedicao_UnidadeID",
                table: "SolicitacaoServicoItemMedicao",
                column: "UnidadeID");

            migrationBuilder.CreateIndex(
                name: "IX_SolicitacaoServicoItemMedicao_UsuarioID",
                table: "SolicitacaoServicoItemMedicao",
                column: "UsuarioID");
        }
    }
}