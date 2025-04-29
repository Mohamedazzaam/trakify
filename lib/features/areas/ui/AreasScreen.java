import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/area_list_view_model.dart';
import '../view_models/area_detail_view_model.dart';
import '../../../../core/widgets/bg_shape_scaffold.dart';
import '../../../../core/theming/app_colors.dart';
import '../data/repositories/area_repository.dart';
import '../models/area_view_model.dart';
import 'widgets/all_areas_widget.dart';
import 'widgets/area_list_tile.dart';
import 'area_screen.dart';

class AreasScreen extends StatelessWidget {
  const AreasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AreaListViewModel(
        repository: AreaRepository(),
      ),
      child: const _AreasScreenContent(),
    );
  }
}

class _AreasScreenContent extends StatelessWidget {
  const _AreasScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BgShapeScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('My Areas'),
        centerTitle: true,
      ),
      body: Column(
        children: const [
          AllAreasWidget(),
          Expanded(child: _AreaListView()),
        ],
      ),
    );
  }
}

class _AreaListView extends StatelessWidget {
  const _AreaListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AreaListViewModel>(context);

    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null) {
      return Center(child: Text('Error: ${viewModel.errorMessage}'));
    }

    if (!viewModel.hasAreas) {
      return const Center(
        child: Text('No areas found. Add your first area!'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: viewModel.areas.length,
      itemBuilder: (context, index) {
        final area = viewModel.areas[index];
        
        // تحويل البيانات من الـ model إلى الـ viewModel للعرض
        final areaViewModel = AreaViewModel.fromModel(
          area,
          cardColor: Color(0xFFDDEDE8),
          titleColor: Colors.black,
          subtitleColor: Colors.black,
          iconColor: Colors.black,
        );
        
        return Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
          child: AreaListTile(
            area: areaViewModel,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                    create: (context) => AreaDetailViewModel(
                      repository: AreaRepository(),
                      areaId: area.id,
                    ),
                    child: AreaScreen(areaId: area.id),
                  ),
                ),
              ).then((_) => viewModel.loadAreas());
            },
          ),
        );
      },
    );
  }
}