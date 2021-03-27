section {* WebAssembly Base Definitions *}

theory Wasm_Base_Defs
  imports
    Wasm_Ast
    Wasm_Type_Abs
    "Word_Lib.Most_significant_bit"
begin

instantiation i32 :: wasm_int_ops begin
  lift_definition zero_i32 :: i32 is "of_nat 0" .
  definition len_of_i32 :: "i32 itself \<Rightarrow> nat" where [simp]: "len_of_i32 _ = 32"
  lift_definition int_clz_i32 :: "i32 \<Rightarrow> i32" is undefined .
  lift_definition int_ctz_i32 :: "i32 \<Rightarrow> i32" is undefined .
  lift_definition int_popcnt_i32 :: "i32 \<Rightarrow> i32" is undefined .
  (* binops *)
  lift_definition int_add_i32 :: "i32 \<Rightarrow> i32 \<Rightarrow> i32" is "(+)" .
  lift_definition int_sub_i32 :: "i32 \<Rightarrow> i32 \<Rightarrow> i32" is "(-)" .
  lift_definition int_mul_i32 :: "i32 \<Rightarrow> i32 \<Rightarrow> i32" is "(*)" .
  lift_definition int_div_u_i32 :: "i32 \<Rightarrow> i32 \<Rightarrow> i32 option" is
    "\<lambda>a b. if b = 0 then None else Some (a div b)" .
  lift_definition int_div_s_i32 :: "i32 \<Rightarrow> i32 \<Rightarrow> i32 option" is undefined .
  lift_definition int_rem_u_i32 :: "i32 \<Rightarrow> i32 \<Rightarrow> i32 option" is undefined .
  lift_definition int_rem_s_i32 :: "i32 \<Rightarrow> i32 \<Rightarrow> i32 option" is undefined .
  lift_definition int_and_i32 :: "i32 \<Rightarrow> i32 \<Rightarrow> i32" is undefined .
  lift_definition int_or_i32 :: "i32 \<Rightarrow> i32 \<Rightarrow> i32" is undefined .
  lift_definition int_xor_i32 :: "i32 \<Rightarrow> i32 \<Rightarrow> i32" is undefined .
  lift_definition int_shl_i32 :: "i32 \<Rightarrow> i32 \<Rightarrow> i32" is undefined .
  lift_definition int_shr_u_i32 :: "i32 \<Rightarrow> i32 \<Rightarrow> i32" is undefined .
  lift_definition int_shr_s_i32 :: "i32 \<Rightarrow> i32 \<Rightarrow> i32" is undefined .
  lift_definition int_rotl_i32 :: "i32 \<Rightarrow> i32 \<Rightarrow> i32" is undefined .
  lift_definition int_rotr_i32 :: "i32 \<Rightarrow> i32 \<Rightarrow> i32" is undefined .
  (* testops *)
  definition int_eqz_i32 :: "i32 \<Rightarrow> bool" where "int_eqz_i32 a \<equiv> undefined"
  (* relops *)
  definition int_eq_i32 :: "i32 \<Rightarrow> i32 \<Rightarrow> bool" where "int_eq_i32 a b \<equiv> undefined"
  definition int_lt_u_i32 :: "i32 \<Rightarrow> i32 \<Rightarrow> bool" where "int_lt_u_i32 a b \<equiv> undefined"
  definition int_lt_s_i32 :: "i32 \<Rightarrow> i32 \<Rightarrow> bool" where "int_lt_s_i32 a b \<equiv> undefined"
  definition int_gt_u_i32 :: "i32 \<Rightarrow> i32 \<Rightarrow> bool" where "int_gt_u_i32 a b \<equiv> undefined"
  definition int_gt_s_i32 :: "i32 \<Rightarrow> i32 \<Rightarrow> bool" where "int_gt_s_i32 a b \<equiv> undefined"
  definition int_le_u_i32 :: "i32 \<Rightarrow> i32 \<Rightarrow> bool" where "int_le_u_i32 a b \<equiv> undefined"
  definition int_le_s_i32 :: "i32 \<Rightarrow> i32 \<Rightarrow> bool" where "int_le_s_i32 a b \<equiv> undefined"
  definition int_ge_u_i32 :: "i32 \<Rightarrow> i32 \<Rightarrow> bool" where "int_ge_u_i32 a b \<equiv> undefined"
  definition int_ge_s_i32 :: "i32 \<Rightarrow> i32 \<Rightarrow> bool" where "int_ge_s_i32 a b \<equiv> undefined"

  lift_definition nat_of_int_i32 :: "i32 \<Rightarrow> nat" is "unat" .
  lift_definition int_of_nat_i32 :: "nat \<Rightarrow> i32" is "of_nat" .
instance by standard simp
end

lemma nonzero_i32: "x \<noteq> 0 \<Longrightarrow> Rep_i32 x \<noteq> 0"
  unfolding zero_i32.abs_eq Abs_fnat_hom_0[THEN sym]
proof (rule ccontr)
  assume "x \<noteq> Abs_i32 0" "\<not> Rep_i32 x \<noteq> 0"
  hence "x \<noteq> Abs_i32 (Rep_i32 x)" by simp
  thus False using Rep_i32_inverse by fastforce
qed

lemma nonneg_i32: "abs_int (x::i32) \<ge> 0"
  unfolding nat_of_int_i32_def by fastforce

lemma nonzero_i32_int: "(x::i32) \<noteq> 0 \<Longrightarrow> abs_int x > 0"
proof -
  assume x: "x \<noteq> 0"
  have "abs_int x \<noteq> 0"
    unfolding nat_of_int_i32.rep_eq using nonzero_i32[OF x]
    by (simp add: unsigned_eq_0_iff)
  thus ?thesis using nonneg_i32 by fastforce
qed

instantiation i32 :: wasm_int begin
instance
proof (standard, goal_cases)
  case 1
  show ?case unfolding nat_of_int_i32_def using zero_i32.rep_eq by simp
next
  case (2 a b)
  have "(x::32 word) + y = word_of_int ((uint x + uint y) mod (2^32))" for x y
    apply (subst word_add_def)
    apply (subst word_uint.norm_norm(1)[THEN sym])
    by simp
  then show ?case unfolding int_add_i32_def int_of_nat_i32_def nat_of_int_i32_def by simp
next
  case (3 a b)
  have "(x::32 word) - y = word_of_int ((uint x - uint y) mod (2^32))" for x y
    apply (subst word_sub_wi)
    apply (subst word_uint.norm_norm(1)[THEN sym])
    by simp
  then show ?case unfolding int_sub_i32_def int_of_nat_i32_def nat_of_int_i32_def by simp
next
  case (4 a b)
  have "(x::32 word) * y = word_of_int ((uint x * uint y) mod (2^32))" for x y
    apply (subst word_mult_def)
    apply (subst word_uint.norm_norm(1)[THEN sym])
    by simp
  then show ?case unfolding int_mul_i32_def int_of_nat_i32_def nat_of_int_i32_def by simp
next
  case (5 b a)
  then show ?case unfolding int_div_u_i32_def using zero_i32.rep_eq by simp
next
  case (6 b a)
  hence "abs_int b > 0" by (rule nonzero_i32_int)
  hence "abs_int a div abs_int b = trunc (rat_of_int (abs_int a) / rat_of_int (abs_int b))"
    apply (subst floor_divide_of_int_eq[THEN sym])
    apply (subst trunc)
    by simp
  hence "Abs_i32 (Rep_i32 a div Rep_i32 b) =
    rep_int (trunc ((rat_of_int \<circ> int \<circ> unat) (Rep_i32 a) / (rat_of_int \<circ> int \<circ> unat) (Rep_i32 b)))"
    (* TODO: fix this ugliness *)
    by (metis (mono_tags, hide_lams) int_of_nat_i32.abs_eq map_fun_apply map_fun_def nat_of_int_i32.rep_eq uint_div_distrib uint_nat unat_eq_nat_uint word_unat.Rep_inverse)
  thus ?case unfolding int_div_u_i32_def nat_of_int_i32_def using nonzero_i32[OF 6] by simp
qed

end

instantiation i64 :: wasm_int begin instance sorry end
instantiation f32 :: wasm_float begin instance .. end
instantiation f64 :: wasm_float begin instance .. end

consts
  (* inter-type conversions *)
  (* float to i32 *)
  ui32_trunc_f32 :: "f32 \<Rightarrow> i32 option"
  si32_trunc_f32 :: "f32 \<Rightarrow> i32 option"
  ui32_trunc_f64 :: "f64 \<Rightarrow> i32 option"
  si32_trunc_f64 :: "f64 \<Rightarrow> i32 option"
  (* float to i64 *)
  ui64_trunc_f32 :: "f32 \<Rightarrow> i64 option"
  si64_trunc_f32 :: "f32 \<Rightarrow> i64 option"
  ui64_trunc_f64 :: "f64 \<Rightarrow> i64 option"
  si64_trunc_f64 :: "f64 \<Rightarrow> i64 option"
  (* int to f32 *)
  f32_convert_ui32 :: "i32 \<Rightarrow> f32"
  f32_convert_si32 :: "i32 \<Rightarrow> f32"
  f32_convert_ui64 :: "i64 \<Rightarrow> f32"
  f32_convert_si64 :: "i64 \<Rightarrow> f32"
  (* int to f64 *)
  f64_convert_ui32 :: "i32 \<Rightarrow> f64"
  f64_convert_si32 :: "i32 \<Rightarrow> f64"
  f64_convert_ui64 :: "i64 \<Rightarrow> f64"
  f64_convert_si64 :: "i64 \<Rightarrow> f64"
  (* intra-{int/float} conversions *)
  wasm_wrap :: "i64 \<Rightarrow> i32"
  wasm_extend_u :: "i32 \<Rightarrow> i64"
  wasm_extend_s :: "i32 \<Rightarrow> i64"
  wasm_demote :: "f64 \<Rightarrow> f32"
  wasm_promote :: "f32 \<Rightarrow> f64"
  (* boolean encoding *)
  serialise_i32 :: "i32 \<Rightarrow> bytes"
  serialise_i64 :: "i64 \<Rightarrow> bytes"
  serialise_f32 :: "f32 \<Rightarrow> bytes"
  serialise_f64 :: "f64 \<Rightarrow> bytes"
  deserialise_i32 :: "bytes \<Rightarrow> i32"
  deserialise_i64 :: "bytes \<Rightarrow> i64"
  deserialise_f32 :: "bytes \<Rightarrow> f32"
  deserialise_f64 :: "bytes \<Rightarrow> f64"
  wasm_bool :: "bool \<Rightarrow> i32"
  int32_minus_one :: i32

  (* memory *)
definition mem_size :: "mem \<Rightarrow> nat" where
  "mem_size m = (mem_length m) div Ki64"

abbreviation "mem_agree m \<equiv> pred_option ((\<le>) (mem_size m)) (mem_max m)"

definition mem_grow :: "mem \<Rightarrow> nat \<Rightarrow> mem option" where
  "mem_grow m n = (let len = (mem_size m) + n in
                   if (len \<le> 2^16 \<and> pred_option (\<lambda>max. len \<le> max) (mem_max m))
                    then Some (mem_append m (n * Ki64) zero_byte)
                    else None)"

definition load :: "mem \<Rightarrow> nat \<Rightarrow> off \<Rightarrow> nat \<Rightarrow> bytes option" where
  "load m n off l = (if (mem_length m \<ge> (n+off+l))
                       then Some (read_bytes m (n+off) l)
                       else None)"

definition sign_extend :: "sx \<Rightarrow> nat \<Rightarrow> bytes \<Rightarrow> bytes" where
  "sign_extend sx l bytes = (let msb = msb_byte (msbyte bytes) in
                          let byte = (case sx of U \<Rightarrow> zero_byte | S \<Rightarrow> if msb then negone_byte else zero_byte) in
                          bytes_takefill byte l bytes)"

definition load_packed :: "sx \<Rightarrow> mem \<Rightarrow> nat \<Rightarrow> off \<Rightarrow> nat \<Rightarrow> nat \<Rightarrow> bytes option" where
  "load_packed sx m n off lp l = map_option (sign_extend sx l) (load m n off lp)"

definition store :: "mem \<Rightarrow> nat \<Rightarrow> off \<Rightarrow> bytes \<Rightarrow> nat \<Rightarrow> mem option" where
  "store m n off bs l = (if (mem_length m \<ge> (n+off+l))
                          then Some (write_bytes m (n+off) (bytes_takefill zero_byte l bs))
                          else None)"

definition store_packed :: "mem \<Rightarrow> nat \<Rightarrow> off \<Rightarrow> bytes \<Rightarrow> nat \<Rightarrow> mem option" where
  "store_packed = store"

consts
  (* host *)
  host_apply :: "s \<Rightarrow> tf \<Rightarrow> host \<Rightarrow> v list \<Rightarrow> host_state \<Rightarrow> (s \<times> v list) option \<Rightarrow> bool"

definition wasm_deserialise :: "bytes \<Rightarrow> t \<Rightarrow> v" where
  "wasm_deserialise bs t = (case t of
                              T_i32 \<Rightarrow> ConstInt32 (deserialise_i32 bs)
                            | T_i64 \<Rightarrow> ConstInt64 (deserialise_i64 bs)
                            | T_f32 \<Rightarrow> ConstFloat32 (deserialise_f32 bs)
                            | T_f64 \<Rightarrow> ConstFloat64 (deserialise_f64 bs))"

definition typeof :: " v \<Rightarrow> t" where
  "typeof v = (case v of
                 ConstInt32 _ \<Rightarrow> T_i32
               | ConstInt64 _ \<Rightarrow> T_i64
               | ConstFloat32 _ \<Rightarrow> T_f32
               | ConstFloat64 _ \<Rightarrow> T_f64)"

definition option_projl :: "('a \<times> 'b) option \<Rightarrow> 'a option" where
  "option_projl x = map_option fst x"

definition option_projr :: "('a \<times> 'b) option \<Rightarrow> 'b option" where
  "option_projr x = map_option snd x"

definition t_length :: "t \<Rightarrow> nat" where
 "t_length t = (case t of
                  T_i32 \<Rightarrow> 4
                | T_i64 \<Rightarrow> 8
                | T_f32 \<Rightarrow> 4
                | T_f64 \<Rightarrow> 8)"

definition tp_length :: "tp \<Rightarrow> nat" where
 "tp_length tp = (case tp of
                 Tp_i8 \<Rightarrow> 1
               | Tp_i16 \<Rightarrow> 2
               | Tp_i32 \<Rightarrow> 4)"

definition is_int_t :: "t \<Rightarrow> bool" where
 "is_int_t t = (case t of
                  T_i32 \<Rightarrow> True
                | T_i64 \<Rightarrow> True
                | T_f32 \<Rightarrow> False
                | T_f64 \<Rightarrow> False)"

definition is_float_t :: "t \<Rightarrow> bool" where
 "is_float_t t = (case t of
                    T_i32 \<Rightarrow> False
                  | T_i64 \<Rightarrow> False
                  | T_f32 \<Rightarrow> True
                  | T_f64 \<Rightarrow> True)"

definition is_mut :: "tg \<Rightarrow> bool" where
  "is_mut tg = (tg_mut tg = T_mut)"

definition unop_t_agree :: "unop \<Rightarrow> t \<Rightarrow> bool" where
  "unop_t_agree unop t =
     (case unop of
        Unop_i _ \<Rightarrow> is_int_t t
      | Unop_f _ \<Rightarrow> is_float_t t)"

definition binop_t_agree :: "binop \<Rightarrow> t \<Rightarrow> bool" where
  "binop_t_agree binop t =
     (case binop of
        Binop_i _ \<Rightarrow> is_int_t t
      | Binop_f _ \<Rightarrow> is_float_t t)"

definition relop_t_agree :: "relop \<Rightarrow> t \<Rightarrow> bool" where
  "relop_t_agree relop t =
     (case relop of
        Relop_i _ \<Rightarrow> is_int_t t
      | Relop_f _ \<Rightarrow> is_float_t t)"

definition app_unop_i :: "unop_i \<Rightarrow> 'i::wasm_int \<Rightarrow> 'i::wasm_int" where
  "app_unop_i iop c =
     (case iop of
     Ctz \<Rightarrow> int_ctz c
   | Clz \<Rightarrow> int_clz c
   | Popcnt \<Rightarrow> int_popcnt c)"

definition app_unop_i_v :: "unop_i \<Rightarrow> v \<Rightarrow> v" where
  "app_unop_i_v iop v =
    (case v of
       (ConstInt32 c) \<Rightarrow> ConstInt32 (app_unop_i iop c)
     | (ConstInt64 c) \<Rightarrow> ConstInt64 (app_unop_i iop c)
     | v' \<Rightarrow> v')"

definition app_unop_f :: "unop_f \<Rightarrow> 'f::wasm_float \<Rightarrow> 'f::wasm_float" where
  "app_unop_f fop c =
                 (case fop of
                    Neg \<Rightarrow> float_neg c
                  | Abs \<Rightarrow> float_abs c
                  | Ceil \<Rightarrow> float_ceil c
                  | Floor \<Rightarrow> float_floor c
                  | Trunc \<Rightarrow> float_trunc c
                  | Nearest \<Rightarrow> float_nearest c
                  | Sqrt \<Rightarrow> float_sqrt c)"

definition app_unop_f_v :: "unop_f \<Rightarrow> v \<Rightarrow> v" where
  "app_unop_f_v fop v =
    (case v of
       (ConstFloat32 c) \<Rightarrow> ConstFloat32 (app_unop_f fop c)
     | (ConstFloat64 c) \<Rightarrow> ConstFloat64 (app_unop_f fop c)
     | v' \<Rightarrow> v')"

definition app_unop :: "unop \<Rightarrow> v \<Rightarrow> v" where
  "app_unop uop v =
    (case uop of
       Unop_i iop \<Rightarrow> app_unop_i_v iop v
     | Unop_f fop \<Rightarrow> app_unop_f_v fop v)"

definition app_binop_i :: "binop_i \<Rightarrow> 'i::wasm_int \<Rightarrow> 'i::wasm_int \<Rightarrow> ('i::wasm_int) option" where
  "app_binop_i iop c1 c2 = (case iop of
                              Add \<Rightarrow> Some (int_add c1 c2)
                            | Sub \<Rightarrow> Some (int_sub c1 c2)
                            | Mul \<Rightarrow> Some (int_mul c1 c2)
                            | Div U \<Rightarrow> int_div_u c1 c2
                            | Div S \<Rightarrow> int_div_s c1 c2
                            | Rem U \<Rightarrow> int_rem_u c1 c2
                            | Rem S \<Rightarrow> int_rem_s c1 c2
                            | And \<Rightarrow> Some (int_and c1 c2)
                            | Or \<Rightarrow> Some (int_or c1 c2)
                            | Xor \<Rightarrow> Some (int_xor c1 c2)
                            | Shl \<Rightarrow> Some (int_shl c1 c2)
                            | Shr U \<Rightarrow> Some (int_shr_u c1 c2)
                            | Shr S \<Rightarrow> Some (int_shr_s c1 c2)
                            | Rotl \<Rightarrow> Some (int_rotl c1 c2)
                            | Rotr \<Rightarrow> Some (int_rotr c1 c2))"

definition app_binop_i_v :: "binop_i \<Rightarrow> v \<Rightarrow> v \<Rightarrow> v option" where
  "app_binop_i_v iop v1 v2 =
    (case (v1,v2) of
       ((ConstInt32 c1), (ConstInt32 c2)) \<Rightarrow> map_option ConstInt32 (app_binop_i iop c1 c2)
     | ((ConstInt64 c1), (ConstInt64 c2)) \<Rightarrow> map_option ConstInt64 (app_binop_i iop c1 c2)
     | _ \<Rightarrow> None)"

definition app_binop_f :: "binop_f \<Rightarrow> 'f::wasm_float \<Rightarrow> 'f::wasm_float \<Rightarrow> ('f::wasm_float) option" where
  "app_binop_f fop c1 c2 = (case fop of
                              Addf \<Rightarrow> Some (float_add c1 c2)
                            | Subf \<Rightarrow> Some (float_sub c1 c2)
                            | Mulf \<Rightarrow> Some (float_mul c1 c2)
                            | Divf \<Rightarrow> Some (float_div c1 c2)
                            | Min \<Rightarrow> Some (float_min c1 c2)
                            | Max \<Rightarrow> Some (float_max c1 c2)
                            | Copysign \<Rightarrow> Some (float_copysign c1 c2))"

definition app_binop_f_v :: "binop_f \<Rightarrow> v \<Rightarrow> v \<Rightarrow> v option" where
  "app_binop_f_v fop v1 v2 =
    (case (v1,v2) of
       ((ConstFloat32 c1), (ConstFloat32 c2)) \<Rightarrow> map_option ConstFloat32 (app_binop_f fop c1 c2)
     | ((ConstFloat64 c1), (ConstFloat64 c2)) \<Rightarrow> map_option ConstFloat64 (app_binop_f fop c1 c2)
     | _ \<Rightarrow> None)"

definition app_binop :: "binop \<Rightarrow> v \<Rightarrow> v \<Rightarrow> v option" where
  "app_binop bop v1 v2 =
    (case bop of
       Binop_i iop \<Rightarrow> app_binop_i_v iop v1 v2
     | Binop_f fop \<Rightarrow> app_binop_f_v fop v1 v2)"

definition app_testop_i :: "testop \<Rightarrow> 'i::wasm_int \<Rightarrow> bool" where
  "app_testop_i testop c = (case testop of Eqz \<Rightarrow> int_eqz c)"

definition app_testop :: "testop \<Rightarrow> v \<Rightarrow> v" where
  "app_testop op v =
    (case v of
       ConstInt32 c \<Rightarrow> ConstInt32 (wasm_bool (app_testop_i op c))
     | ConstInt64 c \<Rightarrow> ConstInt32 (wasm_bool (app_testop_i op c))
     | _ \<Rightarrow> ConstInt32 0)"


definition app_relop_i :: "relop_i \<Rightarrow> 'i::wasm_int \<Rightarrow> 'i::wasm_int \<Rightarrow> bool" where
  "app_relop_i rop c1 c2 = (case rop of
                              Eq \<Rightarrow> int_eq c1 c2
                            | Ne \<Rightarrow> int_ne c1 c2
                            | Lt U \<Rightarrow> int_lt_u c1 c2
                            | Lt S \<Rightarrow> int_lt_s c1 c2
                            | Gt U \<Rightarrow> int_gt_u c1 c2
                            | Gt S \<Rightarrow> int_gt_s c1 c2
                            | Le U \<Rightarrow> int_le_u c1 c2
                            | Le S \<Rightarrow> int_le_s c1 c2
                            | Ge U \<Rightarrow> int_ge_u c1 c2
                            | Ge S \<Rightarrow> int_ge_s c1 c2)"

definition app_relop_i_v :: "relop_i \<Rightarrow> v \<Rightarrow> v \<Rightarrow> v" where
  "app_relop_i_v iop v1 v2 =
    (case (v1,v2) of
       ((ConstInt32 c1), (ConstInt32 c2)) \<Rightarrow> ConstInt32 (wasm_bool (app_relop_i iop c1 c2))
     | ((ConstInt64 c1), (ConstInt64 c2)) \<Rightarrow> ConstInt32 (wasm_bool (app_relop_i iop c1 c2))
     | _ \<Rightarrow> ConstInt32 0)"

definition app_relop_f :: "relop_f \<Rightarrow> 'f::wasm_float \<Rightarrow> 'f::wasm_float \<Rightarrow> bool" where
  "app_relop_f rop c1 c2 = (case rop of
                              Eqf \<Rightarrow> float_eq c1 c2
                            | Nef \<Rightarrow> float_ne c1 c2
                            | Ltf \<Rightarrow> float_lt c1 c2
                            | Gtf \<Rightarrow> float_gt c1 c2
                            | Lef \<Rightarrow> float_le c1 c2
                            | Gef \<Rightarrow> float_ge c1 c2)"

definition app_relop_f_v :: "relop_f \<Rightarrow> v \<Rightarrow> v \<Rightarrow> v" where
  "app_relop_f_v fop v1 v2 =
    (case (v1,v2) of
       ((ConstFloat32 c1), (ConstFloat32 c2)) \<Rightarrow> ConstInt32 (wasm_bool (app_relop_f fop c1 c2))
     | ((ConstFloat64 c1), (ConstFloat64 c2)) \<Rightarrow> ConstInt32 (wasm_bool (app_relop_f fop c1 c2))
     | _ \<Rightarrow> ConstInt32 0)"

definition app_relop :: "relop \<Rightarrow> v \<Rightarrow> v \<Rightarrow> v" where
  "app_relop rop v1 v2 =
    (case rop of
       Relop_i iop \<Rightarrow> app_relop_i_v iop v1 v2
     | Relop_f fop \<Rightarrow> app_relop_f_v fop v1 v2)"

definition types_agree :: "t \<Rightarrow> v \<Rightarrow> bool" where
  "types_agree t v = (typeof v = t)"

definition cl_type :: "cl \<Rightarrow> tf" where
  "cl_type cl = (case cl of Func_native _ tf _ _ \<Rightarrow> tf | Func_host tf _ \<Rightarrow> tf)"

definition rglob_is_mut :: "global \<Rightarrow> bool" where
  "rglob_is_mut g = (g_mut g = T_mut)"

definition stypes :: "s \<Rightarrow> inst \<Rightarrow> nat \<Rightarrow> tf" where
  "stypes s i j = ((types i)!j)"
  
definition sfunc_ind :: "inst \<Rightarrow> nat \<Rightarrow> nat" where
  "sfunc_ind i j = ((inst.funcs i)!j)"

definition sfunc :: "s \<Rightarrow> inst \<Rightarrow> nat \<Rightarrow> cl" where
  "sfunc s i j = (funcs s)!(sfunc_ind i j)"

definition sglob_ind :: "s \<Rightarrow> inst \<Rightarrow> nat \<Rightarrow> nat" where
  "sglob_ind s i j = ((inst.globs i)!j)"
  
definition sglob :: "s \<Rightarrow> inst \<Rightarrow> nat \<Rightarrow> global" where
  "sglob s i j = (globs s)!(sglob_ind s i j)"

definition sglob_val :: "s \<Rightarrow> inst \<Rightarrow> nat \<Rightarrow> v" where
  "sglob_val s i j = g_val (sglob s i j)"

definition smem_ind :: "s \<Rightarrow> inst \<Rightarrow> nat option" where
  "smem_ind s i = (case (inst.mems i) of (n#_) \<Rightarrow> Some n | [] \<Rightarrow> None)"

definition stab_cl_ind :: "s \<Rightarrow> nat \<Rightarrow> nat \<Rightarrow> i option" where
  "stab_cl_ind s i j = (let stabinst = fst ((tabs s)!i) in
                   (if ((length stabinst) > j) then (stabinst!j)
                    else None))"

definition stab :: "s \<Rightarrow> inst \<Rightarrow> nat \<Rightarrow> i option" where
  "stab s i j = (case (inst.tabs i) of (k#_) => stab_cl_ind s k j | [] => None)"

definition supdate_glob_s :: "s \<Rightarrow> nat \<Rightarrow> v \<Rightarrow> s" where
  "supdate_glob_s s k v = s\<lparr>globs := (globs s)[k:=((globs s)!k)\<lparr>g_val := v\<rparr>]\<rparr>"

definition supdate_glob :: "s \<Rightarrow> inst \<Rightarrow> nat \<Rightarrow> v \<Rightarrow> s" where
  "supdate_glob s i j v = (let k = sglob_ind s i j in supdate_glob_s s k v)"

definition is_const :: "e \<Rightarrow> bool" where
  "is_const e = (case e of Basic (C _) \<Rightarrow> True | _ \<Rightarrow> False)"
    
definition const_list :: "e list \<Rightarrow> bool" where
  "const_list xs = list_all is_const xs"

definition tab_extension :: "tabinst \<Rightarrow> tabinst \<Rightarrow> bool" where
  "tab_extension t1 t2 \<equiv> tab_size t1 \<le> tab_size t2 \<and>
                         (tab_max t1) = (tab_max t2)"

definition mem_extension :: "mem \<Rightarrow> mem \<Rightarrow> bool" where
  "mem_extension m1 m2 \<equiv> mem_size m1 \<le> mem_size m2 \<and>
                         (mem_max m1) = (mem_max m2)"

definition global_extension :: "global \<Rightarrow> global \<Rightarrow> bool" where
  "global_extension g1 g2 \<equiv> (g_mut g1 = g_mut g2) \<and> (typeof (g_val g1) = typeof (g_val g2)) \<and> (g_mut g1 = T_immut \<longrightarrow> g_val g1 = g_val g2)"

inductive store_extension :: "s \<Rightarrow> s \<Rightarrow> bool" where
"\<lbrakk>fs = fs'; list_all2 tab_extension tclss tclss'; list_all2 mem_extension bss bss'; list_all2 global_extension gs gs'\<rbrakk>
  \<Longrightarrow> store_extension \<lparr>s.funcs = fs, s.tabs = tclss, s.mems = bss, s.globs = gs\<rparr>
                       \<lparr>s.funcs = fs'@fs'', s.tabs = tclss'@tclss'', s.mems = bss'@bss'', s.globs = gs'@gs''\<rparr>"

abbreviation to_e_list :: "b_e list \<Rightarrow> e list" ("$* _" 60) where
  "to_e_list b_es \<equiv> map Basic b_es"

abbreviation v_to_e_list :: "v list \<Rightarrow> e list" ("$C* _" 60) where
  "v_to_e_list ves \<equiv> map (\<lambda>v. $C v) ves"

  (* Lfilled depth thing-to-fill fill-with result *)
inductive Lfilled :: "nat \<Rightarrow> Lholed \<Rightarrow> e list \<Rightarrow> e list \<Rightarrow> bool" where
  (* "Lfill (LBase vs es') es = vs @ es @ es'" *)
  L0:"\<lbrakk>lholed = (LBase vs es')\<rbrakk> \<Longrightarrow> Lfilled 0 lholed es (($C* vs) @ es @ es')"
  (* "Lfill (LRec vs ts es' l es'') es = vs @ [Label ts es' (Lfill l es)] @ es''" *)
| LN:"\<lbrakk>lholed = (LRec vs n es' l es''); Lfilled k l es lfilledk\<rbrakk> \<Longrightarrow> Lfilled (k+1) lholed es (($C* vs) @ [Label n es' lfilledk] @ es'')"

  (* Lfilled depth thing-to-fill fill-with result *)
inductive Lfilled_exact :: "nat \<Rightarrow> Lholed \<Rightarrow> e list \<Rightarrow> e list \<Rightarrow> bool" where
  (* "Lfill (LBase vs es') es = vs @ es @ es'" *)
  L0:"\<lbrakk>lholed = (LBase [] [])\<rbrakk> \<Longrightarrow> Lfilled_exact 0 lholed es es"
  (* "Lfill (LRec vs ts es' l es'') es = vs @ [Label ts es' (Lfill l es)] @ es''" *)
| LN:"\<lbrakk>lholed = (LRec vs n es' l es''); Lfilled_exact k l es lfilledk\<rbrakk> \<Longrightarrow> Lfilled_exact (k+1) lholed es (($C* vs) @ [Label n es' lfilledk] @ es'')"

definition load_store_t_bounds :: "a \<Rightarrow> tp option \<Rightarrow> t \<Rightarrow> bool" where
  "load_store_t_bounds a tp t = (case tp of
                                   None \<Rightarrow> 2^a \<le> t_length t
                                 | Some tp \<Rightarrow> 2^a \<le> tp_length tp \<and> tp_length tp < t_length t \<and>  is_int_t t)"

definition cvt_i32 :: "sx option \<Rightarrow> v \<Rightarrow> i32 option" where
  "cvt_i32 sx v = (case v of
                   ConstInt32 c \<Rightarrow> None
                 | ConstInt64 c \<Rightarrow> Some (wasm_wrap c)
                 | ConstFloat32 c \<Rightarrow> (case sx of
                                        Some U \<Rightarrow> ui32_trunc_f32 c
                                      | Some S \<Rightarrow> si32_trunc_f32 c
                                      | None \<Rightarrow> None)
                 | ConstFloat64 c \<Rightarrow> (case sx of
                                        Some U \<Rightarrow> ui32_trunc_f64 c
                                      | Some S \<Rightarrow> si32_trunc_f64 c
                                      | None \<Rightarrow> None))"

definition cvt_i64 :: "sx option \<Rightarrow> v \<Rightarrow> i64 option" where
  "cvt_i64 sx v = (case v of
                   ConstInt32 c \<Rightarrow> (case sx of
                                        Some U \<Rightarrow> Some (wasm_extend_u c)
                                      | Some S \<Rightarrow> Some (wasm_extend_s c)
                                      | None \<Rightarrow> None)
                 | ConstInt64 c \<Rightarrow> None
                 | ConstFloat32 c \<Rightarrow> (case sx of
                                        Some U \<Rightarrow> ui64_trunc_f32 c
                                      | Some S \<Rightarrow> si64_trunc_f32 c
                                      | None \<Rightarrow> None)
                 | ConstFloat64 c \<Rightarrow> (case sx of
                                        Some U \<Rightarrow> ui64_trunc_f64 c
                                      | Some S \<Rightarrow> si64_trunc_f64 c
                                      | None \<Rightarrow> None))"

definition cvt_f32 :: "sx option \<Rightarrow> v \<Rightarrow> f32 option" where
  "cvt_f32 sx v = (case v of
                   ConstInt32 c \<Rightarrow> (case sx of
                                      Some U \<Rightarrow> Some (f32_convert_ui32 c)
                                    | Some S \<Rightarrow> Some (f32_convert_si32 c)
                                    | _ \<Rightarrow> None)
                 | ConstInt64 c \<Rightarrow> (case sx of
                                      Some U \<Rightarrow> Some (f32_convert_ui64 c)
                                    | Some S \<Rightarrow> Some (f32_convert_si64 c)
                                    | _ \<Rightarrow> None)
                 | ConstFloat32 c \<Rightarrow> None
                 | ConstFloat64 c \<Rightarrow> Some (wasm_demote c))"

definition cvt_f64 :: "sx option \<Rightarrow> v \<Rightarrow> f64 option" where
  "cvt_f64 sx v = (case v of
                   ConstInt32 c \<Rightarrow> (case sx of
                                      Some U \<Rightarrow> Some (f64_convert_ui32 c)
                                    | Some S \<Rightarrow> Some (f64_convert_si32 c)
                                    | _ \<Rightarrow> None)
                 | ConstInt64 c \<Rightarrow> (case sx of
                                      Some U \<Rightarrow> Some (f64_convert_ui64 c)
                                    | Some S \<Rightarrow> Some (f64_convert_si64 c)
                                    | _ \<Rightarrow> None)
                 | ConstFloat32 c \<Rightarrow> Some (wasm_promote c)
                 | ConstFloat64 c \<Rightarrow> None)"

definition cvt :: "t \<Rightarrow> sx option \<Rightarrow> v \<Rightarrow> v option" where
  "cvt t sx v = (case t of
                 T_i32 \<Rightarrow> (case (cvt_i32 sx v) of Some c \<Rightarrow> Some (ConstInt32 c) | None \<Rightarrow> None)
               | T_i64 \<Rightarrow> (case (cvt_i64 sx v) of Some c \<Rightarrow> Some (ConstInt64 c) | None \<Rightarrow> None) 
               | T_f32 \<Rightarrow> (case (cvt_f32 sx v) of Some c \<Rightarrow> Some (ConstFloat32 c) | None \<Rightarrow> None)
               | T_f64 \<Rightarrow> (case (cvt_f64 sx v) of Some c \<Rightarrow> Some (ConstFloat64 c) | None \<Rightarrow> None))"

definition bits :: "v \<Rightarrow> bytes" where
  "bits v = (case v of
               ConstInt32 c \<Rightarrow> (serialise_i32 c)
             | ConstInt64 c \<Rightarrow> (serialise_i64 c)
             | ConstFloat32 c \<Rightarrow> (serialise_f32 c)
             | ConstFloat64 c \<Rightarrow> (serialise_f64 c))"

definition bitzero :: "t \<Rightarrow> v" where
  "bitzero t = (case t of
                T_i32 \<Rightarrow> ConstInt32 0
              | T_i64 \<Rightarrow> ConstInt64 0
              | T_f32 \<Rightarrow> ConstFloat32 0
              | T_f64 \<Rightarrow> ConstFloat64 0)"

definition n_zeros :: "t list \<Rightarrow> v list" where
  "n_zeros ts = (map (\<lambda>t. bitzero t) ts)"

lemma is_int_t_exists:
  assumes "is_int_t t"
  shows "t = T_i32 \<or> t = T_i64"
  using assms
  by (cases t) (auto simp add: is_int_t_def)

lemma is_float_t_exists:
  assumes "is_float_t t"
  shows "t = T_f32 \<or> t = T_f64"
  using assms
  by (cases t) (auto simp add: is_float_t_def)


lemma int_float_disjoint: "is_int_t t = -(is_float_t t)"
  by simp (metis is_float_t_def is_int_t_def t.exhaust t.simps(13-16))

lemma stab_unfold:
  assumes "stab s i j = Some i_cl"
  shows "\<exists>k ks. inst.tabs i = k#ks \<and>
                     length (fst ((tabs s)!k)) > j \<and>
                     (fst ((tabs s)!k))!j = Some i_cl"
  using assms
  unfolding stab_def stab_cl_ind_def
  by (simp add: Let_def split: list.splits if_splits option.splits)

lemma inj_basic: "inj Basic"
  by (meson e.inject(1) injI)

lemma inj_basic_econst: "inj (\<lambda>v. $C v)"
  by (meson b_e.inject(16) e.inject(1) injI)

lemma to_e_list_1:"[$ a] = $* [a]"
  by simp

lemma to_e_list_2:"[$ a, $ b] = $* [a, b]"
  by simp

lemma to_e_list_3:"[$ a, $ b, $ c] = $* [a, b, c]"
  by simp

lemma v_exists_b_e:"\<exists>ves. ($C*vs) = ($*ves)"
proof (induction vs)
  case (Cons a vs)
  thus ?case
  by (metis list.simps(9))
qed auto

lemma Lfilled_exact_imp_Lfilled:
  assumes "Lfilled_exact n lholed es LI"
  shows "Lfilled n lholed es LI"
  using assms
proof (induction rule: Lfilled_exact.induct)
  case (L0 lholed es)
  thus ?case
    using const_list_def Lfilled.intros(1)
    by fastforce
next
  case (LN vs lholed n es' l es'' k es lfilledk)
  thus ?case
    using Lfilled.intros(2)
    by fastforce
qed

lemma Lfilled_exact_app_imp_exists_Lfilled:
  assumes "Lfilled_exact n lholed (($C* vs)@es) LI"
  shows "\<exists>lholed'. Lfilled n lholed' es LI"
  using assms
proof (induction "(($C* vs)@es)" LI rule: Lfilled_exact.induct)
  case (L0 lholed)
  thus ?case
    using Lfilled.intros(1)
    by force
next
  case (LN vs lholed n es' l es'' k lfilledk)
  thus ?case
    using Lfilled.intros(2)
    by fastforce
qed

lemma Lfilled_imp_exists_Lfilled_exact:
  assumes "Lfilled n lholed es LI"
  shows "\<exists>lholed' vs es_c. Lfilled_exact n lholed' (($C* vs)@es@es_c) LI"
  using assms Lfilled_exact.intros
  by (induction rule: Lfilled.induct) fastforce+

lemma n_zeros_typeof:
  "n_zeros ts = vs \<Longrightarrow> (ts = map typeof vs)"
proof (induction ts arbitrary: vs)
  case Nil
  thus ?case
    unfolding n_zeros_def
    by simp
next
  case (Cons t ts)
  obtain vs' where "n_zeros ts = vs'"
    using n_zeros_def
    by blast
  moreover
  have "typeof (bitzero t) = t"
    unfolding typeof_def bitzero_def
    by (cases t, simp_all)
  ultimately
  show ?case
    using Cons
    unfolding n_zeros_def
    by auto
qed

end
