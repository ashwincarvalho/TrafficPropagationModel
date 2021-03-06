
for ticks in tick_list_short

	counts, unit = ticks_to_time_string(ticks)

	# Past Acceleration
	fname_str = "PastAcc$counts$unit"
	feature_name = symbol("Feature_" * fname_str)
	str_description  = "the longitudinal acceleration $counts $unit ago"
	sym_feature = symbol("pastacc$counts$unit")
	lstr = latexstring("{a}^\text{past}_{-$counts$unit}")

	create_feature_basics( fname_str, UnextractableFeature, "m/s2", false, false, Inf, -Inf, true, sym_feature, lstr, str_description)

	@eval begin
		function _get(::$feature_name, pdset::PrimaryDataset, carind::Int, validfind::Int)

			jump = -$ticks

			carid = carind == CARIND_EGO ? CARID_EGO : carind2id(pdset, carind, validfind)


			jvfind1 = int(jumpframe(pdset, validfind, jump))
			jvfind2 = int(jumpframe(pdset, validfind, jump+1))
			if jvfind1 == 0 || jvfind2 == 0 # Does not exist
				return NA_ALIAS
			end

			cur, fut = 0.0, 0.0
			if carind == CARIND_EGO
				curr = get(SPEED, pdset, CARIND_EGO, jvfind1)
				past = get(SPEED, pdset, CARIND_EGO, jvfind2)
			elseif idinframe(pdset, carid, jvfind1) && idinframe(pdset, carid, jvfind2)
				ind1 = carid2ind(pdset, carid, jvfind1)
				ind2 = carid2ind(pdset, carid, jvfind2)
				curr = get(SPEED, pdset, ind1, jvfind1)
				past = get(SPEED, pdset, ind2, jvfind2)
			else
				return NA_ALIAS
			end

			(curr - past)/SEC_PER_FRAME
		end
	end


end

