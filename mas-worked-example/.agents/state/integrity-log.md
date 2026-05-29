<!--
integrity-log.md — append-only log of /health-check persistence-integrity scans (checks 7-11).
Owner: /health-check prompt. Spec: parent template Libraries/core/validation-and-recovery.md.
-->

# Integrity Log

This file is append-only. Schema follows the parent template (Multi-Agent-System repo, `Libraries/core/validation-and-recovery.md` and `Template/.agents/state/integrity-log.template.md`).

## IL-001: Project baseline scan

- Date: 2026-05-26T17:50:57Z
- Trigger: kickoff (first /health-check after initial commit)
- git_head: d5c3265360a92be0d0eac7db7ad86a144f01aa3a
- files_scanned: 52
- sha256_baseline: 2601323ace3427c4b6aa9d65a29958d09f29a4416d06e0c8a00e7adbc080d9e0
- Check 7  (git fsck):       pass — empty output from `git fsck --full --strict`
- Check 8  (hash readback):  baseline — no prior IL; manifest established below; next scan re-derives and compares
- Check 9  (cross-ref):      pass — 0 `ref:`/`refs:` citations expected in a docs-only KB project; this repo carries no `Libraries/` index, so the citation grammar is unused
- Check 10 (encoding audit): pass — BOM=0, ESC=0 across 50 .md files
- Check 11 (remote sync):    pass — `origin` resolves to `C:\Users\mmcka\git-bares\mas-worked-example.git` (local-bare); `ls-remote refs/heads/master` matches HEAD
- Verdict: healthy
- Notes: First IL entry. Downstream worked example consuming the Multi-Agent-System template. Scan scope: every tracked file under repo root (`git ls-files`), excluding `.git/`. Working tree clean at commit `d5c3265`. Kickoff outputs: profile locked at 2026-05-26T18:00:00Z, plan @ Concept phase, handoff Orchestrator→Architect, checkpoint turn_token=1.
- turn_token: 1

### IL-001 hash manifest

```
7aa3d55273e4ed2c6b3b16023b2346657c24dcd628e6add86bff47113cf05c8e  .agents/state/artifact-manifest.template.md
6bea3e6ada6e4ffdf520c97a17ca4f58f023be881f3df644ac70c9eb28293543  .agents/state/artifacts.template.md
4129f84ac4979d8a91dfb8a0f7646b6a3af4fec2ac39f905f7e3a0f56df7b736  .agents/state/checkpoint.md
075c964e4c6c63303b2289f058b38300763cff2efe255f01628bd34c5566ead9  .agents/state/checkpoint.template.md
c928cb95c8e792e76f8290c8d028e84a83c9437c605c2c06b024a6d84608630b  .agents/state/decisions.template.md
5775b9bc2a75509ca5a17faabb4d31068e60303d6b267e71fe2e758f6f9d87bf  .agents/state/handoff.md
81b2a9182488560dafd054113f5deb2b6b30d86a4edc5dd2fcb0db6c93bf1150  .agents/state/integrity-log.template.md
22c0c635307a0d1c61523a005deba83b3ce9e9b1a699cb96694f9b7ed328c077  .agents/state/plan.md
a832fc5e79b02bf023b9e7b1ded7d1e237ef29b52c4b808b6db7172e613adf13  .agents/state/plan.template.md
c5d64fbe3c49b5658edfaddb15c43045e5fd2e87baac175f03377a0e84236ec6  .agents/state/project-profile.md
31cb1ec175e412a4c6a77b077417bdc9622ccb25ef3c7467a82ee6f41ca9140c  .agents/state/project-profile.template.md
4d48c306f2b9cee06a05fd8799c018328e3d8dd130c51c7737def327285d5ae0  .agents/state/README.md
903da48cfe9c9b5df1198bd315617e6622a726c00577e488d200242176ac3703  .agents/state/role-manifest.template.md
2481ca3b1bdeb074e28625014bb0768d1486219ae922e52e8547a4c45502a192  .agents/state/validation-log.template.md
13abbd710d9ddb8e0ce3ee750e9328df316bb0e95455e7f123d4ebec664fd022  .github/chatmodes/accessibility.chatmode.md
855076677d5244d983886b7bbefd695f7b923f31c457c65f94276bb26b2bf7d3  .github/chatmodes/architect.chatmode.md
f0dbc673f1af43f1246e67ce0bf89d7a193fdef9e55b6662a1b891dbee43084c  .github/chatmodes/builder.chatmode.md
7d0756f1e319cdcf3647781954bf4523ca52d58d8aac8bf41edfd62c90d70879  .github/chatmodes/compliance-officer.chatmode.md
fcb0e0edecd85e270b71554f10eaa66b20b35da18fedd13e327a0af72ec11137  .github/chatmodes/data-steward.chatmode.md
3295f8f7d6d61538db1595ecac1455e8559a72d7172e27dabcbd03c19fe15125  .github/chatmodes/database-engineer.chatmode.md
3a6057481527b1c77bde857e6619e9aa35de2f9df8e0f898d9bbc2fc2daa2f18  .github/chatmodes/documenter.chatmode.md
2f317c2742583512845d60300a41ea7fde263b9df15e07fac0f2639570a35ec3  .github/chatmodes/finops.chatmode.md
7d5af101df5610dacf192a1ecc578c02b7cc7e3eecf089c7fa16f0f0eff580d3  .github/chatmodes/legal.chatmode.md
68e52aa5c48daa101924975e972586993dc217beeccbd4ca4272306eee283c61  .github/chatmodes/librarian.chatmode.md
c5a43bce73d774c298a4887c9f5901d91fd0e41ec5fad0e0b6dd6fcf8dd52a68  .github/chatmodes/maintainer.chatmode.md
05b6e401d08b3fc38f2ed20dcdea844288e5ab61ce2c84cc152d6e6de4863312  .github/chatmodes/orchestrator.chatmode.md
6b0f7749891dc353307012a3c85e9c7b197ed8dfd582bb08c4b65260f5b2ea81  .github/chatmodes/privacy-engineer.chatmode.md
7dec395baa29725e33d26a343f900e47ecc5fdfe303ba2ff0626fce3782e04a2  .github/chatmodes/product.chatmode.md
30dd495f4758714450656e0eb86b3ed7acb0634c6f3d94711f0d61f3a54b0983  .github/chatmodes/qa.chatmode.md
1de62957c629c0ff49c2180d9de9526690b28c06825755c713e789aa40ad4e14  .github/chatmodes/rai.chatmode.md
022d1b42420334399bcb14c13c70729883c4227bd259b18e6de95fe7aa672274  .github/chatmodes/release-manager.chatmode.md
4204ef971bcf31df6964c4789367bff8932c1a0ff2ccdbe80d78bf15e91ca663  .github/chatmodes/reviewer.chatmode.md
0dcf28a1cdb943c3cb951b131f8ed24a2d3c0349e377a0f0928276d43f302e46  .github/chatmodes/security-engineer.chatmode.md
65245062f0c6724549e8beadbc83cdfe9a142e1db2600daca5e775a21b4cd53f  .github/chatmodes/sre.chatmode.md
d7c786d287843cff2b1ac5cf2eacd6a01f1728501898893b9d92e7baf9deb6e3  .github/chatmodes/support.chatmode.md
e51b5d246d0333596c4f19a9efe32b857510db9698a6dfc4a928e280018cb509  .github/chatmodes/ux-researcher.chatmode.md
86129cd7de88c0483c76096c76c317f37edff64aff98d02f7edda75c010f372a  .github/chatmodes/validator.chatmode.md
1d28cfc02f08199320fb65816b692de384d9f4f852f28b311583e599a2d2b3a5  .github/copilot-instructions.md
0a8f628806eee334839815dc268f8c8daa8398ee8478bd18847ea1c8df250bf2  .github/instructions/general.instructions.md
b11237fa830633cc1f2fa62c7a07a020bbd01cc2293bb81abe1c64c2f55b34ab  .github/instructions/security.instructions.md
8a40dd9e22e0957e6c0638b828689047ff73f7d6be1f6f674890aba9739405b3  .github/prompts/handoff.prompt.md
7d16f9dd9ec407d9dce1699fdf18664e161294681ec87363e8bdc5af319cdf2d  .github/prompts/health-check.prompt.md
36bb1680e9353d87bf4126df46a4b9ff40a9697760a29c0bcbe9fd7fc1993659  .github/prompts/kickoff.prompt.md
2d126f6c44d5262b9988ab2ada7f513afb32791725318c56a217ab17430b5307  .github/prompts/migrate-existing.prompt.md
87412c0ece050793b3e3d83b6d5fc4f8c8ac06772b3e4d3655f2d504bed6a0b4  .github/prompts/phase-gate.prompt.md
ad92756baffa6fe601e83d9941d64fb095cfd8044929d6d7a1e18e6d04a8a970  .github/prompts/profile.prompt.md
8adee163bccd5d77e9301a7c32cb89a4b3514a08fe6d724936a72267e46658ac  .github/prompts/recover.prompt.md
986785cae49225cbc234f00353f69f968dd43126cae7089d52a60b48ec8b19bf  .github/prompts/validate.prompt.md
3f69312bcc090aa8c6bd619a63f4a9638300b6c11a0a9247b4194fc70543e1bd  .gitignore
5087aece6dc642306b711d25efa634b6600deddee57bb5285f26c13d67682109  .vscode/mcp.json
f51fb04784ca27055eb0bbd1e9a8942067e70ad80cf4b46adc70a7d4d8bb7d80  AGENTS.md
20b707facf1259c2a0259b704132a6cbbd20348668f773b042cff0d128d44fd3  README.md
```
